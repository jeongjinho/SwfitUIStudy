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
    case counter(CounterAction)
    case primeModal(PrimeModelAction)
    case favoritePrimes(FavoritePrimesAction)
    
    public var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }
    public var primeModal: PrimeModelAction? {
        get {
            guard case let .primeModal(value) = self else { return nil }
            return value
        }
        
        set {
            guard case .primeModal = self, let newValue = newValue else { return }
            self = .primeModal(newValue)
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

let someAction = AppAction.counter(.incrTapped)
typealias CounterViewState = (count: Int, favoritePrimes: [Int])
struct CounterView: View {
    @State private var isPrimeModalShown: Bool = false
    @State private var isPrimeAlertShown: Bool = false
    @StateObject var store: Store<CounterViewState, AppAction>
    @State var alertNthPrime: Int?
    @State var isNthPrimeButtonDisabled: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                
                Button("-") {
                    self.store.send(.counter(.decrTapped))
                }
                
                Text("\(self.store.value.count)")
                
                Button("+") {
                    self.store.send(.counter(.incrTapped))
                }
                
            }
            Button("Is this prime?") {
                isPrimeModalShown.toggle()
            }
            
            Button("What's the \(ordinal(self.store.value.count)) prime?") {
                nthPrimeButtonAction()
            }
            .disabled(isNthPrimeButtonDisabled)
        }
        .font(.title)
        .navigationTitle("Counter demo")
        
        .popover(isPresented: $isPrimeModalShown) {
            IsPrimeModalView(store: self.store.view { ($0.count, $0.favoritePrimes)})
            
        }
        .alert("the prime\(self.store.value.count) prime is \(alertNthPrime ?? 0)", isPresented: $isPrimeAlertShown, presenting: alertNthPrime) { nthPrime in
            
            Button("OK", role: .cancel, action: {})
        }
    }
    
    func nthPrimeButtonAction() {
        isNthPrimeButtonDisabled = true
        nthPrime(self.store.value.count) { prime in
            self.alertNthPrime = prime
            self.isPrimeAlertShown = true
            self.isNthPrimeButtonDisabled = false
        }
    }
}

struct IsPrimeModalView: View {
    
    @StateObject var store: Store<PrimeModalState, AppAction>
    
    
    var body: some View {
        VStack {
            
            if isPrime(self.store.value.count) {
                Text("\(self.store.value.count) is prime!! ❤️‍🔥")
                if self.store.value.favoritePrimes.contains(self.store.value.count) {
                    Button {
                        self.store.send(.primeModal(.removeFavoritePrimeTapped))
                        
                    } label: {
                        Text("Remove from favorite primes")
                    }
                } else {
                    Button {
                        self.store.send(.primeModal(.saveFavoritePrimeTapped))
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


//struct CounterView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        CounterView(
//            store: Store(initialValue: AppState(), reducer: appReducer
//                        )
//        )
//    }
//}

private func ordinal(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(for: n) ?? ""
}

public let wolframAlphaApiKey = "6H69Q3-828TKQJ4EP"
func wolframAlpha(query: String, callback: @escaping (WolframAlphaResult?) -> Void) -> Void {
    var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
    components.queryItems = [
        URLQueryItem(name: "input", value: query),
        URLQueryItem(name: "format", value: "plaintext"),
        URLQueryItem(name: "output", value: "JSON"),
        URLQueryItem(name: "appid", value: wolframAlphaApiKey)
    ]
    
    URLSession.shared.dataTask(with: components.url(relativeTo: nil)!) { data, response, error in
        callback(
            data.flatMap{ try? JSONDecoder().decode(WolframAlphaResult.self, from: $0)}
        )
        
    }
    .resume()
}


func nthPrime(_ n: Int, callback: @escaping (Int?) -> Void) -> Void {
    
    wolframAlpha(query: "prime \(n)") { result in
        
        callback(
            result
                .flatMap {
                    $0.queryresult
                        .pods
                        .first(where: { $0.primary == .some(true)})?
                        .subpods
                        .first?
                        .plaintext
                }
                .flatMap(Int.init)
        )
    }
}


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
