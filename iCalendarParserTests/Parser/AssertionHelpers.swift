//
//  AssertionHelpers.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation
import XCTest

protocol Assertable {
    func assertFailure<T>(value: ValueResult<T>, expectedError: RuleError)
}

extension Assertable {
    func assertFailure<T>(value: ValueResult<T>, expectedError: RuleError) {
        switch value {
        case .value(_):
            XCTFail("Not expecting a value")
        case .error(let error):
            XCTAssert(error == expectedError)
        }
    }
}
