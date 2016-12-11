//
//  PropertyRuleTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/11/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class PropertyRuleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertNode<T: Comparable>(tokens: [Token], expectedName: PropertyName, expectedValue: T) {
        let ruleOutput = PropertyRule().invokeRule(tokens: tokens)
        
        switch ruleOutput {
        case .Node(let parsable):
            let node = parsable as! Node<T>
            switch node.nodeValue {
            case .Property(let name, let value):
                XCTAssert(name == expectedName)
                XCTAssert(value == expectedValue)
            case .Parameter(_, _), .Component(_, _):
                XCTFail("Expecting property, got a component or parameter instead")
            }
        case .None(_):
            XCTFail("Expecting a valid node, got an error instead")
        }

    }
    
    func assertError(tokens: [Token], error: RuleError) {
        let ruleOutput = PropertyRule().invokeRule(tokens: tokens)
        
        switch ruleOutput {
        case .Node(_):
            XCTFail("Expecting a RuleError, got a Node instead")
        case .None(let error):
            XCTAssert(error == error)
        }
    }
    
    func testSimpleNameValueProperty() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator, Token.identifier("This is a summary")]
        assertNode(tokens: inputTokens, expectedName: PropertyName(rawValue: "SUMMARY")!,
                   expectedValue: "This is a summary")
    }
    
    func testUnexpectedTokenCount() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedTokenCount)
    }
    
    func testUnexpectedTokenType() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator, Token.parameterSeparator]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedTokenType)
    }
    
    func testIncorrectSeparator() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.parameterSeparator, Token.identifier("Summary")]
        assertError(tokens: inputTokens, error: RuleError.IncorrectSeparator)
    }
    
    func testUnexpectedName() {
        let inputTokens = [Token.identifier("BOGUS"), Token.valueSeparator, Token.identifier("Summary")]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedName)
    }

}
