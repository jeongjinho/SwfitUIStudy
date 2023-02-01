//
//  Counter.swift
//  Counter
//
//  Created by jeong jinho on 2023/01/04.
//

import SwiftUI
import PrimeModal
import ComposableArchitecture

public enum CounterViewAction {
    case counter(CounterAction)
    case primeModal(PrimeModelAction)
    
  public  var counter: CounterAction? {
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

}

public enum CounterAction {
    case incrTapped
    case decrTapped
}

public typealias CounterViewState = (count: Int, favoritePrimes: [Int])

public func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .incrTapped:
        state += 1
    case .decrTapped:
        state -= 1
    }
}


public struct CounterView: View {
    @State private var isPrimeModalShown: Bool = false
    @State private var isPrimeAlertShown: Bool = false
    @StateObject var store: Store<CounterViewState, CounterViewAction>
    @State var alertNthPrime: Int?
    @State var isNthPrimeButtonDisabled: Bool = false
    
    public init(store: Store<CounterViewState, CounterViewAction>) {
        self._store = StateObject(wrappedValue: store)
    }
    
    public var body: some View {
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
            IsPrimeModalView(store: self.store.view(value: { ($0.count, $0.favoritePrimes)}, action: { .primeModal($0)}))
            
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

public let counterViewReducer: (inout CounterViewState, CounterViewAction) -> Void = combine(
    pullback(counterReducer, value: \CounterViewState.count, action: \CounterViewAction.counter),
    pullback(primeModalReducer, value: \.self , action: \.primeModal)
)

struct CounterView_Previews: PreviewProvider {
    
    
    static var previews: some View {
       CounterView(store: Store<CounterViewState, CounterViewAction>(initialValue: (1_000_000, []), reducer: counterViewReducer ))
    }
}
