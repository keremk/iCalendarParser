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
    
    func assertNodeValue<T>(result: Result<Parsable, RuleError>, expectedNodeValue: NodeValue<T>){
        let result = result.flatMap { (node) -> Result<Parsable, RuleError> in
            if let node = node as? Node<T> {
                XCTAssert(node.nodeValue == expectedNodeValue)
            }
            return Result<Parsable, RuleError>.success(node as! Node<T>) // TODO: Find a better way. For now this is always called by Node result types
        }
        
        if case .failure(let error) = result {
            XCTFail("Expecting to success, instead failed with \(error.localizedDescription)")
        }
        
    }
    
    func assertError2<T>(result: Result<T, RuleError>, expectedError: RuleError) {
        switch result {
        case .success(_):
            XCTFail("Expecting a RuleError, got a Node instead")
        case .failure(let error as RuleError):
            XCTAssert(error == expectedError)
        default:
            XCTFail("Unknown error type, must be RuleError")
        }
    }
}
