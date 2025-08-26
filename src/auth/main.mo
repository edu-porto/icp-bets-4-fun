import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Error "mo:base/Error";
import Time "mo:base/Time";
import Int "mo:base/Int";

shared actor class Auth() = {
    
    // Types
    type UserId = Principal;
    type UserProfile = {
        id: UserId;
        username: ?Text;
        balance: Nat;
        createdAt: Int;
        lastActive: Int;
    };

    type AuthResult = {
        #Success: UserProfile;
        #Error: Text;
    };

    // State
    private stable var userCount: Nat = 0;
    private var users = HashMap.HashMap<UserId, UserProfile>(0, Principal.equal, Principal.hash);
    
    // Events for future governance token integration
    type UserEvent = {
        #UserCreated: {userId: UserId; timestamp: Int};
        #BalanceUpdated: {userId: UserId; oldBalance: Nat; newBalance: Nat; timestamp: Int};
    };

    // System functions
    system func preupgrade() {
        // Convert HashMap to stable format for upgrades
    };

    system func postupgrade() {
        // Convert stable format back to HashMap after upgrades
    };

    // Public functions
    public shared query func whoami() : async Principal {
        msg.caller
    };

    public shared({caller}) func createUser(username: ?Text) : async AuthResult {
        if (Principal.isAnonymous(caller)) {
            return #Error("Anonymous users cannot create accounts");
        };

        switch (users.get(caller)) {
            case (?existingUser) {
                #Error("User already exists")
            };
            case null {
                let newUser: UserProfile = {
                    id = caller;
                    username = username;
                    balance = 1000; // Starting balance of 1000 credits
                    createdAt = Time.now();
                    lastActive = Time.now();
                };
                
                users.put(caller, newUser);
                userCount += 1;
                
                #Success(newUser)
            };
        };
    };

    public shared query({caller}) func getUserProfile() : async ?UserProfile {
        users.get(caller)
    };

    public shared({caller}) func updateBalance(newBalance: Nat) : async Bool {
        switch (users.get(caller)) {
            case (?user) {
                let updatedUser: UserProfile = {
                    id = user.id;
                    username = user.username;
                    balance = newBalance;
                    createdAt = user.createdAt;
                    lastActive = Time.now();
                };
                users.put(caller, updatedUser);
                true
            };
            case null {
                false
            };
        };
    };

    public shared({caller}) func addCredits(amount: Nat) : async Bool {
        switch (users.get(caller)) {
            case (?user) {
                let newBalance = user.balance + amount;
                let updatedUser: UserProfile = {
                    id = user.id;
                    username = user.username;
                    balance = newBalance;
                    createdAt = user.createdAt;
                    lastActive = Time.now();
                };
                users.put(caller, updatedUser);
                true
            };
            case null {
                false
            };
        };
    };

    public shared({caller}) func deductCredits(amount: Nat) : async Bool {
        switch (users.get(caller)) {
            case (?user) {
                if (user.balance < amount) {
                    return false;
                };
                let newBalance = user.balance - amount;
                let updatedUser: UserProfile = {
                    id = user.id;
                    username = user.username;
                    balance = newBalance;
                    createdAt = user.createdAt;
                    lastActive = Time.now();
                };
                users.put(caller, updatedUser);
                true
            };
            case null {
                false
            };
        };
    };

    // Admin functions for future governance
    public shared query({caller}) func getTotalUsers() : async Nat {
        userCount
    };

    public shared query({caller}) func getAllUsers() : async [UserProfile] {
        let userArray = Iter.toArray(users.vals());
        userArray
    };

    // Helper function to check if user exists
    public shared query({caller}) func userExists() : async Bool {
        switch (users.get(caller)) {
            case (?_) { true };
            case null { false };
        };
    };
}; 