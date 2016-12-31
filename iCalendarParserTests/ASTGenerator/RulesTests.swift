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
        assertFailure(result: ruleOutput, expectedError: expectedError)
    }
    
    func testExistingRule() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        let expectedNode = Node<Component>(name: .begin, value: .calendar, type: .container)
        let result = Rules().invokeRule(tokens: inputTokens)
 
        assertNode(node: result.unwrap() as! Node<Component>?, expectedNode: expectedNode)
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
