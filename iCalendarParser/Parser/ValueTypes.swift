//
//  ValueTypes.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/11/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

//    case Boolean
//    case CalendarUserAddress
//    case Date
//    case DateTime
//    case Float
//    case Integer
//    case PeriodOfTime
//    case RecurrenceRule
//    case Text
//    case Time
//    case URI
//    case UTCOffset

protocol ValueMapper {
    associatedtype ValueType: Comparable
    func mapValue(value: String) -> ValueType
}

// As of Swift 3.01, we cannot directly inject a type that complies to a protocol with a generic associated type.
// We need to inject this ParameterRule and Property to rule to convert a String to a desired type.
// So we are using a technique called Type Erasure (See https://krakendev.io/blog/generic-protocols-and-their-shortcomings)
// We basically wrap our concrete mapper that knows how to map to a concrete type with this AnyValueMapper type.
struct AnyValueMapper<T: Comparable>: ValueMapper {
    private let _mapValue: (String) -> T
    
    init<U:ValueMapper>(_ valueMapper: U) where U.ValueType == T {
        _mapValue = valueMapper.mapValue
    }
    
    func mapValue(value: String) -> T {
        return _mapValue(value)
    }
}

extension Bool: Comparable {
    public static func == (lhs: Bool, rhs: Bool) -> Bool {
        return lhs == rhs
    }
    
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        return true
    }
}

struct BooleanMapper: ValueMapper {
    internal func mapValue(value: String) -> Bool {
        return value.toBool()
    }
}

struct TextMapper: ValueMapper {
    internal func mapValue(value: String) -> String {
        return value
    }
}

struct CalenderUserAddressMapper: ValueMapper {
    internal func mapValue(value: String) -> String {
        return value
    }
}

struct DateMapper: ValueMapper {
    internal func mapValue(value: String) -> Date {
        return Date()
    }
}

struct DateTimeMapper: ValueMapper {
    internal func mapValue(value: String) -> Date {
        return Date()
    }
}


struct ComponentValueType: Comparable {
    static func == (lhs: ComponentValueType, rhs: ComponentValueType) -> Bool {
        return true
    }
    
    static func < (lhs: ComponentValueType, rhs: ComponentValueType) -> Bool {
        return true
    }
}
