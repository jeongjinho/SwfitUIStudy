//
//  Counter.swift
//  Counter
//
//  Created by jeong jinho on 2023/01/04.
//

import Foundation

public enum CounterAction {
    case incrTapped
    case decrTapped
}


public func counterReducer(state: inout Int, action: CounterAction) {
    switch action {
    case .incrTapped:
        state += 1
    case .decrTapped:
        state -= 1
    }
}
