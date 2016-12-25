//
//  ComponentRuleTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/11/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ComponentRuleTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertExistingNode(tokens: [Token], expectedComponentType: ComponentType,
                            expectedComponentIndicator: ComponentIndicator) {
        let expectedNodeValue = NodeValue<ComponentValueType>.Component(expectedComponentType, expectedComponentIndicator)
        let result = ComponentRule().invokeRule(tokens: tokens)
        
        assertNodeValue(result: result, expectedNodeValue: expectedNodeValue)
     }
    
    func assertError(tokens: [Token], expectedError: RuleError) {
        let ruleOutput = ComponentRule().invokeRule(tokens: tokens)
        
        assertFailure(result: ruleOutput, expectedError: expectedError)
    }
    
    func testExistingRuleWithBegin() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        assertExistingNode(tokens: inputTokens, expectedComponentType: ComponentType.Calendar,
                           expectedComponentIndicator: ComponentIndicator.Begin)
    }

    func testExistingRuleWithEnd() {
        let inputTokens = [Token.identifier("END"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        assertExistingNode(tokens: inputTokens, expectedComponentType: ComponentType.Calendar,
                           expectedComponentIndicator: ComponentIndicator.End)
    }

    func testUnexpectedTokenValue() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("BOGUS")]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedValue)
    }

    func testUnexpectedTokenCount() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenCount)
    }

    func testUnexpectedTokenType() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.parameterSeparator]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedTokenType)
    }
    
    func testIncorrectSeparator() {
        let inputTokens = [Token.identifier("BEGIN"), Token.parameterSeparator, Token.identifier("VCALENDAR")]
        assertError(tokens: inputTokens, expectedError: RuleError.IncorrectSeparator)
    }

    func testUnexpectedName() {
        let inputTokens = [Token.identifier("BOGUS"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        assertError(tokens: inputTokens, expectedError: RuleError.UnexpectedName)
    }
}
