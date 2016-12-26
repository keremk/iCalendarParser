//
//  BasicMappers.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

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

struct CalenderUserAddressMapper: ValueMapper {
    internal func mapValue(value: String) -> Result<String, RuleError>  {
        return .success(value)
    }
}