//
//  ParameterRuleTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/27/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ParameterRuleTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertError(tokens: [Token], expectedError: RuleError) {
        let ruleOutput = ParameterRule(valueMapper: AnyValueMapper(TextMapper())).invokeRule(tokens: tokens)
        assertFailure(result: ruleOutput, expectedError: expectedError)
    }

    
    func testSimpleNameValueProperty() {
        let inputTokens = [Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE")]
        let expectedNodeValue = NodeValue<Bool>.Parameter(ParameterName.Rsvp, true)
        let result = ParameterRule(valueMapper: AnyValueMapper(BooleanMapper())).invokeRule(tokens: inputTokens)
        
        assertNodeValue(result: result, expectedNodeValue: expectedNodeValue)
    }
    
    func testUnexpectedTokenCount() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.parameterValueSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenCount)
    }
    
    func testUnexpectedTokenType() {
        let inputTokens = [Token.identifier("RSVP"), Token.parameterValueSeparator, Token.parameterSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenType)
    }
    
    func testIncorrectSeparator() {
        let inputTokens = [Token.identifier("RSVP"), Token.valueSeparator, Token.identifier("Summary")]
        assertError(tokens: inputTokens, expectedError: RuleError.IncorrectSeparator)
    }
    
    func testUnexpectedName() {
        let inputTokens = [Token.identifier("BOGUS"), Token.parameterValueSeparator, Token.identifier("Summary")]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedName)
    }
   
}
