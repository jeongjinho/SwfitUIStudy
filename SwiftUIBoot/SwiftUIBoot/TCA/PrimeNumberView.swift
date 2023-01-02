//
//  PrimeNumberView.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/12.
//

import SwiftUI

struct PrimeNumberView: View {
   @StateObject var store: Store<AppState, AppAction>
    var body: some View {


        NavigationView {
            List {
                NavigationLink(destination: CounterView(store: store)) {
                    Text("Counter Demo")
                }.navigationBarTitle("Counter demo")
                
                NavigationLink(destination: FavoritePrimesView(store: store)) {
                    Text("Favorite primes")
                } .navigationBarTitle("State management")
            }
           
        }
        
        
    }
}

struct PrimeNumberView_Previews: PreviewProvider {
//    static let appReducer = combine(combine(pullback(counterReducer(state:action:), { value in
//        value.count
//    }) , primeModalReducer(state:action:)), favoritePrimesReducer(state:action:))
    static var previews: some View {
        PrimeNumberView(
            store: Store(initialValue: AppState(), reducer:  combine(
                pullback(counterReducer(state:action:), value: \.count, action: \.counter) ,
                pullback(primeModalReducer(state:action:), action: \.primeModal) ,
                pullback(favoritePrimesReducer(state:action:), value: \.favoritePrimesState, action: \.favoritePrimes))
            )
        )
    }
}


//let _appReducer = combine(
//    primeModalReducer(state:action:),
//                          pullback(favoritePrimesReducer(state:action:), value: \.favoritePrimesState),
//                          pullback2()
//
//)




//let appReducer = pullback(_appReducer, value: \.self)


extension AppState {
    var favoritePrimesState: FavoritePrimesState {
        get {
            FavoritePrimesState(favoritePrimes: self.favoritePrimes, activityFeed: self.activityFeed)
        }
        
        set {
            self.favoritePrimes = newValue.favoritePrimes
            self.activityFeed = newValue.activityFeed
        }
    }
}
