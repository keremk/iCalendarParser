//
//  Result.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

// Refactor into 1
//   RuleOutput
//   ValueResult

enum Result<Value, E: Error> {
    case success(Value)
    case failure(Error)
}

extension Result {
    func flatMap<U, E>(_ transform: (Value) -> Result<U, E>) -> Result<U, E> {
        switch self {
        case .success(let value): return transform(value)
        case .failure(let error): return .failure(error)
        }
    }    
}

extension Result where Value:Equatable {
    static func == (lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsInnerValue), .success(let rhsInnerValue)):
            return lhsInnerValue == rhsInnerValue
        default:
            return false
        }
    }
}
