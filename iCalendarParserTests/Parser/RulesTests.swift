//
//  RulesTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class RulesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertError(tokens: [Token], error: RuleError) {
        let ruleOutput = Rules().invokeRule(tokens: tokens)
        
        switch ruleOutput {
        case .Node(_):
            XCTFail("Expecting a RuleError, got a Node instead")
        case .None(let error):
            XCTAssert(error == error)
        }
    }
    
    func testExistingRule() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        let expectedNodeValue = NodeValue<ComponentValueType>.Component(.Calendar, .Begin)
        
        let result = Rules().invokeRule(tokens: inputTokens)
        switch result {
        case .Node(let node):
            let componentNode = node as! Node<ComponentValueType>
            XCTAssert(componentNode.nodeValue == expectedNodeValue)
            break
        case .None(_):
            XCTFail("Expecting a valid node not an error.")
        }
        
    }
    
    func testFailingBEGINRules() {
        var inputTokens = [Token.identifier("BEGIN"), Token.parameterSeparator, Token.identifier("VCALENDAR")]
        assertError(tokens: inputTokens, error: RuleError.IncorrectSeparator)
        
        inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.valueSeparator]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedTokenType)
        
        inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedTokenCount)
    }
}