//
//  TokenHelper.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/12/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct TokenHelper {
    static public func extractParameterTokens(tokens: [Token]) -> [[Token]] {
        var propertyTokens:[Token] = []
        var parameterTokens:[Token] = []
        var collectPropertyTokens = true
        
        for token in tokens {
            if token == Token.parameterSeparator {
                collectPropertyTokens = false
            } else if (token == Token.valueSeparator && !collectPropertyTokens) {
                collectPropertyTokens = true
            }
            if collectPropertyTokens {
                propertyTokens.append(token)
            } else {
                parameterTokens.append(token)
            }
        }
        return [propertyTokens, parameterTokens]
    }
}
