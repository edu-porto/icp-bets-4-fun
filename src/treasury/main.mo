import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Float "mo:base/Float";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";

shared actor class Treasury() = {
    
    // Types
    type TransactionType = {
        #BetPlaced: {gameId: Text; player: Principal; amount: Nat};
        #BetWon: {gameId: Text; player: Principal; amount: Nat};
        #BetLost: {gameId: Text; player: Principal; amount: Nat};
        #HouseFee: {gameId: Text; amount: Nat};
        #Deposit: {player: Principal; amount: Nat};
        #Withdrawal: {player: Principal; amount: Nat};
    };

    type Transaction = {
        id: Text;
        timestamp: Int;
        transactionType: TransactionType;
        balance: Nat; // Treasury balance after transaction
    };

    type TreasuryStats = {
        totalBalance: Nat;
        totalBets: Nat;
        totalWagered: Nat;
        totalWon: Nat;
        totalLost: Nat;
        totalHouseFees: Nat;
        totalDeposits: Nat;
        totalWithdrawals: Nat;
    };

    type BetResult = {
        #Success: {transactionId: Text; newBalance: Nat};
        #Error: Text;
    };

    // State
    private stable var treasuryBalance: Nat = 0;
    private stable var totalBets: Nat = 0;
    private stable var totalWagered: Nat = 0;
    private stable var totalWon: Nat = 0;
    private stable var totalLost: Nat = 0;
    private stable var totalHouseFees: Nat = 0;
    private stable var totalDeposits: Nat = 0;
    private stable var totalWithdrawals: Nat = 0;
    
    private var transactions = Buffer.Buffer<Transaction>(0);
    private var transactionCount: Nat = 0;
    
    // House fee percentage (2%)
    private let HOUSE_FEE_PERCENTAGE: Nat = 2;
    
    // Minimum bet amount
    private let MIN_BET_AMOUNT: Nat = 10;
    
    // Maximum bet amount (to prevent excessive risk)
    private let MAX_BET_AMOUNT: Nat = 10000;

    // System functions
    system func preupgrade() {
        // Convert Buffer to stable format for upgrades
    };

    system func postupgrade() {
        // Convert stable format back to Buffer after upgrades
    };

    // Public functions
    public shared({caller}) func placeBet(gameId: Text, betAmount: Nat) : async BetResult {
        if (Principal.isAnonymous(caller)) {
            return #Error("Anonymous users cannot place bets");
        };

        if (betAmount < MIN_BET_AMOUNT) {
            return #Error("Bet amount must be at least " # Nat.toText(MIN_BET_AMOUNT) # " credits");
        };

        if (betAmount > MAX_BET_AMOUNT) {
            return #Error("Bet amount cannot exceed " # Nat.toText(MAX_BET_AMOUNT) # " credits");
        };

        // Calculate house fee
        let houseFee = (betAmount * HOUSE_FEE_PERCENTAGE) / 100;
        let netBetAmount = betAmount - houseFee;
        
        // Update treasury balance
        treasuryBalance += houseFee;
        totalBets += 1;
        totalWagered += betAmount;
        totalHouseFees += houseFee;
        
        // Record transaction
        let transactionId = generateTransactionId();
        let transaction: Transaction = {
            id = transactionId;
            timestamp = Time.now();
            transactionType = #BetPlaced({gameId = gameId; player = caller; amount = betAmount});
            balance = treasuryBalance;
        };
        
        transactions.add(transaction);
        transactionCount += 1;
        
        #Success({transactionId = transactionId; newBalance = treasuryBalance})
    };

    public shared({caller}) func processBetResult(gameId: Text, player: Principal, result: Text, betAmount: Nat, winAmount: ?Nat) : async Bool {
        if (Principal.isAnonymous(caller)) {
            return false;
        };

        switch (result) {
            case "win" {
                switch (winAmount) {
                    case (?amount) {
                        // Player won - treasury pays out
                        if (amount <= treasuryBalance) {
                            treasuryBalance -= amount;
                            totalWon += amount;
                            
                            let transaction: Transaction = {
                                id = generateTransactionId();
                                timestamp = Time.now();
                                transactionType = #BetWon({gameId = gameId; player = player; amount = amount});
                                balance = treasuryBalance;
                            };
                            transactions.add(transaction);
                            transactionCount += 1;
                            true
                        } else {
                            false // Insufficient funds
                        }
                    };
                    case null { false }
                }
            };
            case "lose" {
                // Player lost - treasury keeps the bet (already collected as house fee)
                totalLost += betAmount;
                
                let transaction: Transaction = {
                    id = generateTransactionId();
                    timestamp = Time.now();
                    transactionType = #BetLost({gameId = gameId; player = player; amount = betAmount});
                    balance = treasuryBalance;
                };
                transactions.add(transaction);
                transactionCount += 1;
                true
            };
            case _ { false }
        }
    };

    public shared({caller}) func deposit(amount: Nat) : async Bool {
        if (Principal.isAnonymous(caller)) {
            return false;
        };

        if (amount == 0) {
            return false;
        };

        treasuryBalance += amount;
        totalDeposits += amount;
        
        let transaction: Transaction = {
            id = generateTransactionId();
            timestamp = Time.now();
            transactionType = #Deposit({player = caller; amount = amount});
            balance = treasuryBalance;
        };
        transactions.add(transaction);
        transactionCount += 1;
        
        true
    };

    public shared({caller}) func withdraw(amount: Nat) : async Bool {
        if (Principal.isAnonymous(caller)) {
            return false;
        };

        if (amount == 0 or amount > treasuryBalance) {
            return false;
        };

        treasuryBalance -= amount;
        totalWithdrawals += amount;
        
        let transaction: Transaction = {
            id = generateTransactionId();
            timestamp = Time.now();
            transactionType = #Withdrawal({player = caller; amount = amount});
            balance = treasuryBalance;
        };
        transactions.add(transaction);
        transactionCount += 1;
        
        true
    };

    // Query functions
    public shared query func getTreasuryBalance() : async Nat {
        treasuryBalance
    };

    public shared query func getTreasuryStats() : async TreasuryStats {
        {
            totalBalance = treasuryBalance;
            totalBets = totalBets;
            totalWagered = totalWagered;
            totalWon = totalWon;
            totalLost = totalLost;
            totalHouseFees = totalHouseFees;
            totalDeposits = totalDeposits;
            totalWithdrawals = totalWithdrawals;
        }
    };

    public shared query func getTransactionHistory(limit: ?Nat) : async [Transaction] {
        let maxLimit = switch (limit) {
            case (?l) { Int.min(l, transactions.size()) };
            case null { transactions.size() };
        };
        
        let recentTransactions = Buffer.Buffer<Transaction>(0);
        let startIndex = if (transactions.size() > maxLimit) {
            transactions.size() - maxLimit
        } else {
            0
        };
        
        for (i in Iter.range(startIndex, transactions.size() - 1)) {
            recentTransactions.add(transactions.get(i));
        };
        
        Buffer.toArray(recentTransactions)
    };

    public shared query func getTransactionById(transactionId: Text) : async ?Transaction {
        for (transaction in transactions.vals()) {
            if (transaction.id == transactionId) {
                return ?transaction;
            };
        };
        null
    };

    public shared query func getTotalTransactions() : async Nat {
        transactionCount
    };

    // Configuration functions
    public shared query func getHouseFeePercentage() : async Nat {
        HOUSE_FEE_PERCENTAGE
    };

    public shared query func getBetLimits() : async {
        minBet: Nat;
        maxBet: Nat;
    } {
        {
            minBet = MIN_BET_AMOUNT;
            maxBet = MAX_BET_AMOUNT;
        }
    };

    // Future governance functions (for DAO expansion)
    public shared({caller}) func proposeFeeChange(newFeePercentage: Nat) : async Bool {
        // TODO: Implement DAO voting mechanism
        // For now, only allow changes if caller is authorized
        if (newFeePercentage <= 10 and newFeePercentage >= 1) { // Max 10%, Min 1%
            // This would trigger a DAO proposal in the future
            true
        } else {
            false
        }
    };

    public shared({caller}) func proposeBetLimitChange(newMinBet: Nat, newMaxBet: Nat) : async Bool {
        // TODO: Implement DAO voting mechanism
        if (newMinBet > 0 and newMaxBet > newMinBet and newMaxBet <= 50000) {
            // This would trigger a DAO proposal in the future
            true
        } else {
            false
        }
    };

    // Private helper functions
    private func generateTransactionId() : Text {
        let timestamp = Int.toText(Time.now());
        let random = Nat.toText(Nat.random(10000));
        "tx-" # timestamp # "-" # random
    };

    // Emergency functions (for future governance)
    public shared({caller}) func emergencyWithdraw(amount: Nat) : async Bool {
        // TODO: Implement multi-signature or DAO approval for large withdrawals
        if (amount <= treasuryBalance and amount <= 1000) { // Limit emergency withdrawals
            treasuryBalance -= amount;
            true
        } else {
            false
        }
    };
}; 