//
//  BasicMappers.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct ComponentMapper: ValueMapper {
    internal func mapValue(value: String) -> Result<Component, RuleError> {
        var result: Result<Component, RuleError>
        if let component = Component(rawValue: value) {
            result = .success(component)
        } else {
            result = .failure(RuleError.UnexpectedValue)
        }
        return result
    }
}

struct BooleanMapper: ValueMapper {
    internal func mapValue(value: String) -> Result<Bool, RuleError> {
        var result: Result<Bool, RuleError>
        if let boolValue = Bool(value.lowercased()) {
            result = .success(boolValue)
        } else {
            result = .failure(RuleError.UnexpectedValue)
        }
        return result
    }
}

struct TextMapper: ValueMapper {
    internal func mapValue(value: String) -> Result<String, RuleError>  {
        return .success(value)
    }
}

struct FloatMapper: ValueMapper {
    internal func mapValue(value: String) -> Result<Float, RuleError>  {
        var result: Result<Float, RuleError>
        if let floatValue = Float(value) {
            result = .success(floatValue)
        } else {
            result = .failure(RuleError.UnexpectedValue)
        }
        return result
    }
}

struct IntegerMapper: ValueMapper {
    internal func mapValue(value: String) -> Result<Int, RuleError>  {
        var result: Result<Int, RuleError>
        if let intValue = Int(value) {
            result = .success(intValue)
        } else {
            result = .failure(RuleError.UnexpectedValue)
        }
        return result
    }
}

struct UriMapper: ValueMapper {
    internal func mapValue(value: String) -> Result<URL, RuleError>  {
        var result: Result<URL, RuleError>
        if let urlValue = URL(string: value) {
            result = .success(urlValue)
        } else {
            result = .failure(RuleError.UnexpectedValue)
        }
        return result
    }
}

struct CalendarUserAddressMapper: ValueMapper {
    
    // https://icalendar.org/iCalendar-RFC-5545/3-3-3-calendar-user-address.html
    internal func mapValue(value: String) -> Result<URL, RuleError>  {
        var result: Result<URL, RuleError>
        if let urlValue = URL(string: value) {
            result = .success(urlValue)
        } else {
            result = .failure(RuleError.UnexpectedValue)
        }
        return result
    }
}
