//
//  PropertyRuleTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/11/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class PropertyRuleTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertNode<T: Comparable>(tokens: [Token], expectedName: PropertyName, expectedValue: T) {
        let expectedNodeValue = NodeValue<T>.Property(expectedName, expectedValue)
        let result = PropertyRule().invokeRule(tokens: tokens)
        
        assertNodeValue(result: result, expectedNodeValue: expectedNodeValue)
    }
    
    func assertError(tokens: [Token], expectedError: RuleError) {
        let ruleOutput = PropertyRule().invokeRule(tokens: tokens)
        
        assertError2(result: ruleOutput, expectedError: expectedError)
    }
    
    func testSimpleNameValueProperty() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator, Token.identifier("This is a summary")]
        assertNode(tokens: inputTokens, expectedName: PropertyName(rawValue: "SUMMARY")!,
                   expectedValue: "This is a summary")
    }
    
    func testUnexpectedTokenCount() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenCount)
    }
    
    func testUnexpectedTokenType() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator, Token.parameterSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenType)
    }
    
    func testIncorrectSeparator() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.parameterSeparator, Token.identifier("Summary")]
        assertError(tokens: inputTokens, expectedError: RuleError.IncorrectSeparator)
    }
    
    func testUnexpectedName() {
        let inputTokens = [Token.identifier("BOGUS"), Token.valueSeparator, Token.identifier("Summary")]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedName)
    }

}
