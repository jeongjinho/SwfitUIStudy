//
//  SwiftUIBootApp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/08/30.
//

import SwiftUI

@main
struct SwiftUIBootApp: App {
//    let appReducer = combine(combine(counterReducer(state:action:), primeModalReducer(state:action:)), favoritePrimesReducer(state:action:))
    var body: some Scene {
        WindowGroup {
            PrimeNumberView(
                store: Store(initialValue: AppState(), reducer:  combine(
                    pullback(counterReducer(state:action:), value: \.count, action: \.counter) ,
                    pullback(primeModalReducer(state:action:), action: \.primeModal) ,
                    pullback(favoritePrimesReducer(state:action:), value: \.favoritePrimesState, action: \.favoritePrimes))
                )
                )
        }
    }
}
