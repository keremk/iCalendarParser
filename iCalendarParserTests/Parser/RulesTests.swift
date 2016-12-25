//
//  RulesTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class RulesTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertError(tokens: [Token], expectedError: RuleError) {
        let ruleOutput = Rules().invokeRule(tokens: tokens)
        assertError2(result: ruleOutput, expectedError: expectedError)
    }
    
    func testExistingRule() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        let expectedNodeValue = NodeValue<ComponentValueType>.Component(.Calendar, .Begin)
        let result = Rules().invokeRule(tokens: inputTokens)
 
        assertNodeValue(result: result, expectedNodeValue: expectedNodeValue)
    }
    
    func testFailingBEGINRules() {
        var inputTokens = [Token.identifier("BEGIN"), Token.parameterSeparator, Token.identifier("VCALENDAR")]
        assertError(tokens: inputTokens, expectedError: RuleError.IncorrectSeparator)
        
        inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.valueSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenType)
        
        inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenCount)
    }
}
