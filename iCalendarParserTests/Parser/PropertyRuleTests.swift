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
    
    func assertError(tokens: [Token], expectedError: RuleError) {
        let ruleOutput = PropertyRule(valueMapper: AnyValueMapper(TextMapper())).invokeRule(tokens: tokens)
        assertFailure(result: ruleOutput, expectedError: expectedError)
    }
    
    func testSimpleNameValueProperty() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator, Token.identifier("This is a summary")]
        let expectedNodeValue = NodeValue<String>.Property(PropertyName.Summary, "This is a summary")
        let result = PropertyRule(valueMapper: AnyValueMapper(TextMapper())).invokeRule(tokens: inputTokens)
        
        assertNodeValue(result: result, expectedNodeValue: expectedNodeValue)

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
