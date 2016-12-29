//
//  ValueMapper.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

protocol ValueMapper {
    associatedtype ValueType: Equatable
    func mapValue(value: String) -> Result<ValueType, RuleError>
}

// As of Swift 3.01, we cannot directly inject a type that complies to a protocol with a generic associated type.
// We need to inject a concrete typed ValueMapper to DefaultRule in order to convert a String value to the value of a desired type.
// (for example something that maps String to Bool)
// We are using a technique called Type Erasure (See https://krakendev.io/blog/generic-protocols-and-their-shortcomings)
// We basically wrap our concrete mapper that knows how to map to a concrete type with this AnyValueMapper type.
struct AnyValueMapper<T: Equatable>: ValueMapper {
    private let _mapValue: (String) -> Result<T, RuleError>
    
    init<U: ValueMapper>(_ valueMapper: U) where U.ValueType == T {
        _mapValue = valueMapper.mapValue
    }
    
    func mapValue(value: String) -> Result<T, RuleError> {
        return _mapValue(value)
    }
}
