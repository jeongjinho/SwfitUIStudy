//
//  ComposableArchitecture.swift
//  ComposableArchitecture
//
//  Created by jeong jinho on 2023/01/04.
//

import SwiftUI
import Combine

public func logging<Value, Action>(_ reducer:  @escaping  (inout Value, Action) -> Void) -> (inout Value,Action) -> Void {
    
    return { value, action in
        reducer(&value, action)
        print("Action: \(action)")
        print("Value:")
        dump(value)
        print("---")
    }
}

public final class Store<Value, Action>: ObservableObject {
    
    let reducer: (inout Value , Action) -> Void
    @Published public private(set) var value: Value
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    public func send(_ action :Action) {
        self.reducer(&self.value, action)
        
        
    }
    
    public func view<LocalValue>(_ f: @escaping (Value) -> LocalValue) -> Store <LocalValue, Action> {
        let localStore = Store<LocalValue, Action>(initialValue: f(self.value)) { localValue, action in
            self.send(action)
            let updatedLocalValue = f(self.value)
            localValue = updatedLocalValue
        }
        
        self.$value.sink { [weak localStore] newValue in
            localStore?.value = f(newValue)
        }
        .store(in: &localStore.cancellables)
        return localStore
    }
}


public func pullback<Value, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout Value, LocalAction) -> Void,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout Value, GlobalAction) -> Void {
    return { value, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&value, localAction)
        
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    
    
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
        
    }
}

public struct EnumKeyPath<Root, Value> {
    let embed: (Value) -> Root
    let extract: (inout Root, Value) -> Void
}

public func combine<Value, Action>(
    _ first: @escaping (inout Value, Action) -> Void,
    _ second: @escaping (inout Value, Action) -> Void) -> (inout Value, Action) -> Void {
        
        return { value, action in
            
            first(&value,action)
            second(&value,action)
        }
        
    }

public func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...) -> (inout Value, Action) -> Void {
        
        return { value, action in
            
            for reducer in reducers {
                reducer(&value, action)
            }
        }
        
    }



func transform<A,B, Action>(_ reducer: (inout A,Action) -> Void, f: (A) -> B) -> (inout B, Action) -> Void {
    
    fatalError()
}
