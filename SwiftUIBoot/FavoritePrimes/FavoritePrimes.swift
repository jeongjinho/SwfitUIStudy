//
//  FavoritePrimes.swift
//  FavoritePrimes
//
//  Created by jeong jinho on 2023/01/04.
//

import SwiftUI
import ComposableArchitecture

public enum FavoritePrimesAction {
    case deleteFavoritePrimes(IndexSet)
}

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) {
    switch action {
    case let .deleteFavoritePrimes(indexSet):
        for index in indexSet {
            state.remove(at: index)
        }
    }
}

public struct FavoritePrimesView: View {

    @StateObject var store: Store<[Int], FavoritePrimesAction>
    
    public init(store: Store<[Int], FavoritePrimesAction>) {
        self._store = StateObject(wrappedValue: store)
    }
    
    public var body: some View {
        
        List {
            ForEach(self.store.value , id: \.self) { favorite in
                Text("\(favorite)")
            }
            .onDelete { indexSet in
                
                self.store.send(.deleteFavoritePrimes(indexSet))
                
            }
        }
        .navigationBarTitle("Favorite Primes")
 
    }
    
}
