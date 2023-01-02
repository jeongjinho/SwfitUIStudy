//
//  FavoritePrimesView.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/15.
//

import SwiftUI



struct FavoritePrimesView: View {
    @StateObject var store: Store<AppState, AppAction>
    
    var body: some View {
        
        List {
            ForEach(self.store.value.favoritePrimes , id: \.self) { favorite in
                Text("\(favorite)")
            }
            .onDelete { indexSet in
                
                self.store.send(.favoritePrimes(.deleteFavoritePrimes(indexSet)))
                
            }
        }
        .navigationBarTitle("Favorite Primes")
        
        
    }
    
}





struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePrimesView(
            store: Store(initialValue: AppState(), reducer:  combine(
                pullback(counterReducer(state:action:), value: \.count, action: \.counter) ,
                pullback(primeModalReducer(state:action:), action: \.primeModal) ,
                pullback(favoritePrimesReducer(state:action:), value: \.favoritePrimesState, action: \.favoritePrimes))
            )
        
            )
    }
}
