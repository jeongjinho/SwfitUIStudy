//
//  CounterView.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/13.
//

import SwiftUI

// (A) -> A
// (inout A) -> Void

// (A,B) -> (A,C)
// (inout A, B) -> C

//(Value, Action) -> Value
//(inout Value, Action) -> Void

final class Store<Value, Action>: ObservableObject {
    
    let reducer: (inout Value , Action) -> Void
    @Published var value: Value
    init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    func send(_ action :Action) {
        self.reducer(&self.value, action)
        
    }
}


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

enum CounterAction {
    case incrTapped
    case decrTapped
}

enum PrimeModelAction {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}

enum FavoritePrimesAction {
    case deleteFavoritePrimes(IndexSet)
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


func pullback<Value, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout Value, LocalAction) -> Void,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout Value, GlobalAction) -> Void {
    return { value, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&value, localAction)
        
    }
}


func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .incrTapped:
        state += 1
    case .decrTapped:
        state -= 1
//    default:
//        break
    }
}
struct EnumKeyPath<Root, Value> {
    let embed: (Value) -> Root
    let extract: (inout Root, Value) -> Void
}

func primeModalReducer(state: inout AppState, action: PrimeModelAction) {
    
    switch action {
    case .saveFavoritePrimeTapped:
        state.favoritePrimes.append(state.count)
        state.activityFeed.append(AppState.Activity.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
        
    case .removeFavoritePrimeTapped:
        state.favoritePrimes.removeAll(where: {$0 == state.count})
        state.activityFeed.append(AppState.Activity.init(timestamp: Date(), type: .removeFavoritePrime(state.count)))
        
    default:
        break
    }
}


func favoritePrimesReducer(state: inout FavoritePrimesState, action: FavoritePrimesAction) {
    switch action {
    case let .deleteFavoritePrimes(indexSet):
        for index in indexSet {
            let prime = state.favoritePrimes[index]
            state.favoritePrimes.remove(at: index)
            state.activityFeed.append(AppState.Activity.init(timestamp: Date(), type: .removeFavoritePrime(prime)))
            
        }
        

    }
    
}

struct FavoritePrimesState {
    
    var favoritePrimes: [Int]
    var activityFeed: [AppState.Activity]
}

//
//func appReducer(state: inout AppState, action: AppAction) {
////    var copy = state
//    switch action {
//
//    }
//}

func combine<Value, Action>(
    _ first: @escaping (inout Value, Action) -> Void,
    _ second: @escaping (inout Value, Action) -> Void) -> (inout Value, Action) -> Void {
        
        return { value, action in
            
            first(&value,action)
            second(&value,action)
        }
        
}

func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...) -> (inout Value, Action) -> Void {
        
        return { value, action in
            
            for reducer in reducers {
                reducer(&value, action)
            }
        }
        
}

func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
//    _ get: @escaping (GlobalValue) -> LocalValue,
//    _ set: @escaping (inout GlobalValue, LocalValue) -> Void
) -> (inout GlobalValue, GlobalAction) -> Void {
      
    
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
    //    reducer(&value, localAction)
      reducer(&globalValue[keyPath: value], localAction)
        
    }
}

func pullback2<GlobalValue, Action>(

) -> (inout GlobalValue, Action) -> Void {
      
    
    return { globalValue, action in
      
    }
  
}

//func pullback<LocalValue, GlobalValue, Action>(
//    _ reducer: @escaping (inout LocalValue, Action) -> Void,
//    _ get: @escaping (GlobalValue) -> LocalValue,
//    _ set: @escaping (inout GlobalValue, LocalValue) -> Void
//) -> (inout GlobalValue, Action) -> Void {
//
//
//    return { globalValue, action in
//        var localValue = get(globalValue)
//        reducer(&localValue, action)
//        set(&globalValue, localValue)
//
//    }
//}



struct CounterView: View {
    @State private var isPrimeModalShown: Bool = false
    @State private var isPrimeAlertShown: Bool = false
    @StateObject var store: Store<AppState, AppAction>
    @State var alertNthPrime: Int?
    @State var isNthPrimeButtonDisabled: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                
                Button("-") {
                    self.store.send(.counter(.decrTapped))
               //     self.store.value = counterReducer(state: store.value, action: .decrTapped)
//                    self.store.value.count -= 1
                }
                
                Text("\(self.store.value.count)")
                
                Button("+") {
                    self.store.send(.counter(.incrTapped))
                  //  self.store.value = counterReducer(state: store.value, action: .incrTapped)
                     //self.store.value.count += 1
                    
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
            IsPrimeModalView(store: store)
        
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
    
    @StateObject var store: Store<AppState, AppAction>
    
    
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


struct CounterView_Previews: PreviewProvider {
//   static let appReducer = combine(combine(counterReducer(state:action:), primeModalReducer(state:action:)), favoritePrimesReducer(state:action:))
    static  let _appReducer: (inout AppState, AppAction) -> Void = combine(
    //pullback(counterReducer, value: \AppState.count, action: \AppAction.counter),
    //  pullback(primeModalReducer, value: \.self, action: \.primeModal),
      pullback(favoritePrimesReducer, value: \.favoritePrimesState, action: \.favoritePrimes)
    )
    
    
    
    static var previews: some View {
        CounterView(
            store: Store(initialValue: AppState(), reducer: _appReducer
            )
        )
        
    }
}

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
