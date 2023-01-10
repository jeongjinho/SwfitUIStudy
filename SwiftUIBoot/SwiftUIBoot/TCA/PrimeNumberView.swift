//
//  PrimeNumberView.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/12.
//

import SwiftUI
import ComposableArchitecture
import FavoritePrimes
import Counter
import PrimeModal

struct PrimeNumberView: View {
   @StateObject var store: Store<AppState, AppAction>
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(store: self.store.view{ ($0.count, $0.favoritePrimes)})) {
                    Text("Counter Demo")
                }.navigationBarTitle("Counter demo")
                
                NavigationLink(destination: FavoritePrimesView(store: self.store.view { $0.favoritePrimes  })) {
                    Text("Favorite primes")
                } .navigationBarTitle("State management")
            }
        }
    }
}


func activityFeed(_ reducer: @escaping (inout AppState, AppAction) -> Void) ->
(inout AppState, AppAction) -> Void {
    
    return { state, action in
        
        switch action {
            
        case .counter(_):
            break
        case .primeModal(.removeFavoritePrimeTapped):
            state.activityFeed.append(AppState.Activity.init(timestamp: Date(), type: .removeFavoritePrime(state.count)))
        case .primeModal(.saveFavoritePrimeTapped):
            state.activityFeed.append(AppState.Activity.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
            
        case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
            for index in indexSet {
                state.activityFeed.append(AppState.Activity.init(timestamp: Date(), type: .removeFavoritePrime(state.favoritePrimes[index])))
            }
        }
        reducer(&state, action)
    } 
}


let _appReducer: (inout AppState, AppAction) -> Void =  combine(
    pullback(counterReducer(state:action:), value: \.count, action: \.counter) ,
    pullback(primeModalReducer(state:action:), value: \.primeModal , action: \.primeModal) ,
    pullback(favoritePrimesReducer(state:action:), value: \.favoritePrimes , action: \.favoritePrimes))

let appReducer = pullback(_appReducer, value: \.self, action: \.self)


struct PrimeNumberView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        PrimeNumberView(
            store: Store(
                initialValue: AppState(),
                
                reducer: with(
                    _appReducer,
                    compose(logging,
                            activityFeed
                        )
                )
                
            )
        )
    }
}

public func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {
  return try f(a)
}

public func compose<A, B, C>(
  _ f: @escaping (B) -> C,
  _ g: @escaping (A) -> B
  )
  -> (A) -> C {

    return { (a: A) -> C in
      f(g(a))
    }
}

public func compose<A, B, C, D>(
  _ f: @escaping (C) -> D,
  _ g: @escaping (B) -> C,
  _ h: @escaping (A) -> B
  )
  -> (A) -> D {

    return { (a: A) -> D in
      f(g(h(a)))
    }
}

public func compose<A, B, C, D, E>(
  _ f: @escaping (D) -> E,
  _ g: @escaping (C) -> D,
  _ h: @escaping (B) -> C,
  _ i: @escaping (A) -> B
  )
  -> (A) -> E {

    return { (a: A) -> E in
      f(g(h(i(a))))
    }
}

public func compose<A, B, C, D, E, F>(
  _ f: @escaping (E) -> F,
  _ g: @escaping (D) -> E,
  _ h: @escaping (C) -> D,
  _ i: @escaping (B) -> C,
  _ j: @escaping (A) -> B
  )
  -> (A) -> F {

    return { (a: A) -> F in
      f(g(h(i(j(a)))))
    }
}

public func compose<A, B, C, D, E, F, G>(
  _ f: @escaping (F) -> G,
  _ g: @escaping (E) -> F,
  _ h: @escaping (D) -> E,
  _ i: @escaping (C) -> D,
  _ j: @escaping (B) -> C,
  _ k: @escaping (A) -> B
  )
  -> (A) -> G {

    return { (a: A) -> G in
      f(g(h(i(j(k(a))))))
    }
}
