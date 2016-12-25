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
    func assertValue<T: Equatable>(result: Result<T, RuleError>, expectedValue: T)
    func assertNodeValue<T>(result: Result<Parsable, RuleError>, expectedNodeValue: NodeValue<T>)
    func assertFailure<T>(result: Result<T, RuleError>, expectedError: RuleError)
}

extension Assertable {
    func assertValue<T: Equatable>(result: Result<T, RuleError>, expectedValue: T) {
        let result = result.flatMap { (value) -> Result<T, RuleError> in
            XCTAssert(value == expectedValue)
            return .success(value) // TODO: Find a better way. For now this is always called by Node result types
        }
        
        if case .failure(let error) = result {
            XCTFail("Expecting to success, instead failed with \(error.localizedDescription)")
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
    
    func assertFailure<T>(result: Result<T, RuleError>, expectedError: RuleError) {
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
