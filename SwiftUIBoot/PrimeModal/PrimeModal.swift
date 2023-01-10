//
//  PrimeModal.swift
//  PrimeModal
//
//  Created by jeong jinho on 2023/01/04.
//

import Foundation

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


