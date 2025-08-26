import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Hash "mo:base/Hash";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Random "mo:base/Random";
import Result "mo:base/Result";

shared actor class Game() = {
    
    // Types
    type GameType = {
        #RockPaperScissors;
        #CoinFlip;
    };

    type RPSChoice = {
        #Rock;
        #Paper;
        #Scissors;
    };

    type CoinChoice = {
        #Heads;
        #Tails;
    };

    type GameResult = {
        #Win: Nat;  // Amount won
        #Lose: Nat; // Amount lost
        #Draw: Nat; // Amount returned (no change)
    };

    type GameRecord = {
        id: Text;
        player: Principal;
        gameType: GameType;
        betAmount: Nat;
        playerChoice: Text;
        result: GameResult;
        timestamp: Int;
        randomSeed: Blob;
    };

    type BetRequest = {
        gameType: GameType;
        betAmount: Nat;
        choice: Text;
    };

    // State
    private stable var gameCount: Nat = 0;
    private var games = Buffer.Buffer<GameRecord>(0);
    private var randomGenerator = Random.Finite(0);
    
    // House edge percentage (2%)
    private let HOUSE_EDGE_PERCENTAGE: Nat = 2;
    
    // Game multipliers
    private let RPS_WIN_MULTIPLIER: Nat = 2; // 2x for winning
    private let COINFLIP_WIN_MULTIPLIER: Nat = 2; // 2x for winning

    // System functions
    system func preupgrade() {
        // Convert Buffer to stable format for upgrades
    };

    system func postupgrade() {
        // Convert stable format back to Buffer after upgrades
    };

    // Public functions
    public shared({caller}) func placeBet(request: BetRequest) : async Result.Result<GameRecord, Text> {
        if (Principal.isAnonymous(caller)) {
            return #err("Anonymous users cannot place bets");
        };

        if (request.betAmount == 0) {
            return #err("Bet amount must be greater than 0");
        };

        let gameId = generateGameId();
        let randomSeed = await generateRandomSeed();
        let gameResult = calculateGameResult(request, randomSeed);
        
        let gameRecord: GameRecord = {
            id = gameId;
            player = caller;
            gameType = request.gameType;
            betAmount = request.betAmount;
            playerChoice = request.choice;
            result = gameResult;
            timestamp = Time.now();
            randomSeed = randomSeed;
        };

        games.add(gameRecord);
        gameCount += 1;

        #ok(gameRecord)
    };

    public shared query func getGameHistory(player: ?Principal) : async [GameRecord] {
        switch (player) {
            case (?p) {
                let filteredGames = Buffer.Buffer<GameRecord>(0);
                for (game in games.vals()) {
                    if (game.player == p) {
                        filteredGames.add(game);
                    };
                };
                Buffer.toArray(filteredGames)
            };
            case null {
                Buffer.toArray(games)
            };
        };
    };

    public shared query func getGameById(gameId: Text) : async ?GameRecord {
        for (game in games.vals()) {
            if (game.id == gameId) {
                return ?game;
            };
        };
        null
    };

    public shared query func getTotalGames() : async Nat {
        gameCount
    };

    public shared query func getGameStats(player: ?Principal) : async {
        totalGames: Nat;
        wins: Nat;
        losses: Nat;
        draws: Nat;
        totalWon: Nat;
        totalLost: Nat;
    } {
        let playerGames = switch (player) {
            case (?p) {
                let filtered = Buffer.Buffer<GameRecord>(0);
                for (game in games.vals()) {
                    if (game.player == p) {
                        filtered.add(game);
                    };
                };
                filtered
            };
            case null { games };
        };

        var wins: Nat = 0;
        var losses: Nat = 0;
        var draws: Nat = 0;
        var totalWon: Nat = 0;
        var totalLost: Nat = 0;

        for (game in playerGames.vals()) {
            switch (game.result) {
                case (#Win(amount)) {
                    wins += 1;
                    totalWon += amount;
                };
                case (#Lose(amount)) {
                    losses += 1;
                    totalLost += amount;
                };
                case (#Draw(amount)) {
                    draws += 1;
                };
            };
        };

        {
            totalGames = playerGames.size();
            wins = wins;
            losses = losses;
            draws = draws;
            totalWon = totalWon;
            totalLost = totalLost;
        }
    };

    // Private helper functions
    private func generateGameId() : Text {
        let timestamp = Int.toText(Time.now());
        let random = Nat.toText(Nat.random(10000));
        timestamp # "-" # random
    };

    private func generateRandomSeed() : async Blob {
        let randomBytes = await Random.blob();
        randomBytes
    };

    private func calculateGameResult(request: BetRequest, randomSeed: Blob) : GameResult {
        switch (request.gameType) {
            case (#RockPaperScissors) {
                calculateRPSResult(request.choice, randomSeed, request.betAmount)
            };
            case (#CoinFlip) {
                calculateCoinFlipResult(request.choice, randomSeed, request.betAmount)
            };
        }
    };

    private func calculateRPSResult(playerChoice: Text, randomSeed: Blob, betAmount: Nat) : GameResult {
        let computerChoice = getRandomRPSChoice(randomSeed);
        let playerRPS = textToRPSChoice(playerChoice);
        
        if (playerRPS == computerChoice) {
            // Draw - return bet amount
            #Draw(betAmount)
        } else if (isRPSWinner(playerRPS, computerChoice)) {
            // Win - return 2x bet amount minus house edge
            let winAmount = (betAmount * RPS_WIN_MULTIPLIER * (100 - HOUSE_EDGE_PERCENTAGE)) / 100;
            #Win(winAmount)
        } else {
            // Lose - lose bet amount
            #Lose(betAmount)
        }
    };

    private func calculateCoinFlipResult(playerChoice: Text, randomSeed: Blob, betAmount: Nat) : GameResult {
        let coinResult = getRandomCoinResult(randomSeed);
        let playerCoin = textToCoinChoice(playerChoice);
        
        if (playerCoin == coinResult) {
            // Win - return 2x bet amount minus house edge
            let winAmount = (betAmount * COINFLIP_WIN_MULTIPLIER * (100 - HOUSE_EDGE_PERCENTAGE)) / 100;
            #Win(winAmount)
        } else {
            // Lose - lose bet amount
            #Lose(betAmount)
        }
    };

    private func getRandomRPSChoice(randomSeed: Blob) : RPSChoice {
        let hash = Hash.blake2b(randomSeed);
        let hashArray = Blob.toArray(hash);
        let randomValue = hashArray[0] % 3;
        
        switch (randomValue) {
            case 0 { #Rock };
            case 1 { #Paper };
            case _ { #Scissors };
        }
    };

    private func getRandomCoinResult(randomSeed: Blob) : CoinChoice {
        let hash = Hash.blake2b(randomSeed);
        let hashArray = Blob.toArray(hash);
        let randomValue = hashArray[0] % 2;
        
        switch (randomValue) {
            case 0 { #Heads };
            case _ { #Tails };
        }
    };

    private func textToRPSChoice(text: Text) : RPSChoice {
        switch (Text.map(text, Text.charToLower)) {
            case "rock" { #Rock };
            case "paper" { #Paper };
            case "scissors" { #Scissors };
            case _ { #Rock }; // Default fallback
        }
    };

    private func textToCoinChoice(text: Text) : CoinChoice {
        switch (Text.map(text, Text.charToLower)) {
            case "heads" { #Heads };
            case "tails" { #Tails };
            case _ { #Heads }; // Default fallback
        }
    };

    private func isRPSWinner(player: RPSChoice, computer: RPSChoice) : Bool {
        switch (player, computer) {
            case (#Rock, #Scissors) { true };
            case (#Paper, #Rock) { true };
            case (#Scissors, #Paper) { true };
            case _ { false };
        }
    };

    // Utility functions for frontend
    public shared query func getValidChoices(gameType: GameType) : async [Text] {
        switch (gameType) {
            case (#RockPaperScissors) { ["rock", "paper", "scissors"] };
            case (#CoinFlip) { ["heads", "tails"] };
        }
    };

    public shared query func getHouseEdge() : async Nat {
        HOUSE_EDGE_PERCENTAGE
    };

    public shared query func getWinMultipliers() : async {
        rps: Nat;
        coinFlip: Nat;
    } {
        {
            rps = RPS_WIN_MULTIPLIER;
            coinFlip = COINFLIP_WIN_MULTIPLIER;
        }
    };
}; 