//
//  BasicMappers.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct BooleanMapper: ValueMapper {
    internal func mapValue(value: String) -> ValueResult<Bool> {
        var result: ValueResult<Bool>
        if let boolValue = Bool(value.lowercased()) {
            result = ValueResult<Bool>.value(boolValue)
        } else {
            result = ValueResult<Bool>.error(RuleError.UnexpectedValue)
        }
        return result
    }
}

struct TextMapper: ValueMapper {
    internal func mapValue(value: String) -> ValueResult<String> {
        return ValueResult.value(value)
    }
}

struct CalenderUserAddressMapper: ValueMapper {
    internal func mapValue(value: String) -> ValueResult<String> {
        return ValueResult.value(value)
    }
}
