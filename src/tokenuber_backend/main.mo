// src/simple_token/src/main.mo

import Nat "mo:base/Nat";

actor Token {
    stable var totalSupply : Nat = 0;
    stable var balances : Trie.Trie<Principal, Nat> = Trie.empty();

    public query func balanceOf(who : Principal) : async Nat {
        return Trie.get(who, balances).unwrapOr(0);
    };

    public func transfer(to : Principal, amount : Nat) : async Bool {
        let caller = Principal.fromActor(this);
        let from_balance = Trie.get(caller, balances).unwrapOr(0);
        if (from_balance < amount) {
            return false;
        } else {
            balances := Trie.put(caller, from_balance - amount, balances);
            let to_balance = Trie.get(to, balances).unwrapOr(0);
            balances := Trie.put(to, to_balance + amount, balances);
            return true;
        };
    };

    public func mint(amount : Nat) : async Bool {
        let caller = Principal.fromActor(this);
        totalSupply += amount;
        let balance = Trie.get(caller, balances).unwrapOr(0);
        balances := Trie.put(caller, balance + amount, balances);
        return true;
    };
}
