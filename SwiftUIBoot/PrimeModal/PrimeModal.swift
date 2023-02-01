//
//  PrimeModal.swift
//  PrimeModal
//
//  Created by jeong jinho on 2023/01/04.
//

import SwiftUI
import ComposableArchitecture

public typealias PrimeModalState = (count: Int, favoritePrimes: [Int])

//public struct PrimeModalState {
//    public var count: Int
//    public var favoritePrimes: [Int]
//
//    public init(count: Int, favoritePrimes: [Int]) {
//        self.count = count
//        self.favoritePrimes = favoritePrimes
//    }
//}

public enum PrimeModelAction {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}

public func primeModalReducer(state: inout PrimeModalState, action: PrimeModelAction) {
    
    switch action {
    case .saveFavoritePrimeTapped:
        state.favoritePrimes.append(state.count)
        
    case .removeFavoritePrimeTapped:
        state.favoritePrimes.removeAll(where: {$0 == state.count})

    }
}


public struct IsPrimeModalView: View {
    
    @StateObject var store: Store<PrimeModalState, PrimeModelAction>
    
    public init(store: Store<PrimeModalState, PrimeModelAction>) {
        self._store = StateObject(wrappedValue: store)
    }
    
    public var body: some View {
        VStack {
            
            if isPrime(self.store.value.count) {
                Text("\(self.store.value.count) is prime!! ❤️‍🔥")
                if self.store.value.favoritePrimes.contains(self.store.value.count) {
                    Button {
                        self.store.send(.removeFavoritePrimeTapped)
                        
                    } label: {
                        Text("Remove from favorite primes")
                    }
                } else {
                    Button {
                        self.store.send(.saveFavoritePrimeTapped)
                    } label: {
                        Text("Save to favorite primes")
                    }
                }
                
            } else {
                Text("\(self.store.value.count) is not prime : (")
            }
        }
    }
    
    private func isPrime (_ p: Int) -> Bool {
        if p <= 1 { return false }
        if p <= 3 { return true }
        for i in 2...Int(sqrtf(Float(p))) {
            if p % i == 0 { return false }
        }
        return true
    }
}
