//
//  CounterView.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/13.
//

import SwiftUI
import ComposableArchitecture
import FavoritePrimes
import Counter
import PrimeModal

// (A) -> A
// (inout A) -> Void

// (A,B) -> (A,C)
// (inout A, B) -> C

//(Value, Action) -> Value
//(inout Value, Action) -> Void




struct AppState {
    var count: Int = 0
    var favoritePrimes: [Int] = []
    var loggerdInUser: User?
    var activityFeed: [Activity] = []
    
    struct User {
        let id: Int
        let name: String
        let bio: String
    }
    
    struct Activity {
        let timestamp: Date
        let type: ActivityType
        
        enum ActivityType {
            case addedFavoritePrime(Int)
            case removeFavoritePrime(Int)
        }
    }
}

extension AppState {
    
    var primeModal: PrimeModalState {
        get {
            PrimeModalState(count: self.count, favoritePrimes: self.favoritePrimes)
        }
        
        set {
            self.count = newValue.count
            self.favoritePrimes = newValue.favoritePrimes
        }
    }
    
    var counterView: CounterViewState {
        get {
            CounterViewState(count: self.count, favoritePrimes: self.favoritePrimes)
        }
        
        set {
            self.count = newValue.count
            self.favoritePrimes = newValue.favoritePrimes
        }
    }
}

extension AppState {
    
    mutating func addFavoritePirme() {
        self.favoritePrimes.append(self.count)
        self.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(self.count)))
    }
    
    mutating func removeFavoritePirme(prime: Int) {
        self.favoritePrimes.removeAll(where: {$0 == prime})
        self.activityFeed.append(Activity(timestamp: Date(), type: .removeFavoritePrime(self.count)))
    }
    
    mutating func removeFavoritePrime() {
        self.removeFavoritePirme(prime: self.count)
    }
    
    mutating func removeFavoritePrimes (at indexSet: IndexSet) {
        for index in indexSet {
            self.favoritePrimes.remove(at: index)
        }
    }
}

enum AppAction {
    case counterView(CounterViewAction)
//    case counter(CounterAction)
//    case primeModal(PrimeModelAction)
    case favoritePrimes(FavoritePrimesAction)
    
    public var counterView: CounterViewAction? {
        get {
            guard case let .counterView(value) = self else { return nil }
            return value
        }
        
        set {
            guard case .counterView = self, let newValue = newValue else { return }
            self = .counterView(newValue)
        }
    }
    
    public var favoritePrimes: FavoritePrimesAction? {
        get {
            guard case let .favoritePrimes(value) = self else { return nil }
            return value
        }
        
        set {
            guard case .favoritePrimes = self, let newValue = newValue else { return }
            self = .favoritePrimes(newValue)
        }
    }
}

//let someAction = AppAction.counter(.incrTapped)




func filterActions<Value, Action>(_ predicate: @escaping (Action) -> Bool)
-> (@escaping (inout Value, Action) -> Void)
-> (inout Value, Action) -> Void {
    
    return { reducer in
        return { value, action in
            if predicate(action) {
                reducer(&value,action)
            }
        }
    }
}

struct UndoState<Value> {
    var value: Value
    var history: [Value]
    var canUndo: Bool { !self.history.isEmpty }
    var undone: [Value]
    var canRedo: Bool { !self.undone.isEmpty }
}

enum UndoAction<Action> {
    case action(Action)
    case undo
    case redo
}


func undo<Value, Action>(
    _ reducer: @escaping (inout Value, Action) -> Void, limit: Int) -> (inout UndoState<Value>, UndoAction<Action>) -> Void {
        
        return { undoState, undAction in
            
            switch undAction {
                
            case let .action(action):
                var currentValue = undoState.value
                
                reducer(&currentValue, action)
                undoState.history.append(currentValue)
                
                if undoState.history.count > limit {
                    undoState.history.removeFirst()
                }
                
            case .undo:
                guard undoState.canUndo else { return }
                undoState.undone.append(undoState.value)
                undoState.value = undoState.history.removeLast()
                
            case .redo:
                guard undoState.canRedo else { return }
                undoState.history.append(undoState.value)
                undoState.value = undoState.undone.removeLast()
                
        }
    }
} 
