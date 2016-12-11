//
//  ComponentRuleTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/11/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ComponentRuleTests: XCTestCase {
    
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
        let ruleOutput = ComponentRule().invokeRule(tokens: tokens)
        
        switch ruleOutput {
        case .Node(let parsable):
            let node = parsable as! Node<ComponentValueType>
            switch node.nodeValue {
            case .Component(let componentType, let componentIndicator):
                XCTAssert(componentType == expectedComponentType)
                XCTAssert(componentIndicator == expectedComponentIndicator)
            case .Parameter(_, _), .Property(_, _):
                XCTFail("Expecting component, got a property or parameter instead")
            }
        case .None(_):
            XCTFail("Expecting a valid node, got an error instead")
        }
    }
    
    func assertError(tokens: [Token], error: RuleError) {
        let ruleOutput = ComponentRule().invokeRule(tokens: tokens)
        
        switch ruleOutput {
        case .Node(_):
            XCTFail("Expecting a RuleError, got a Node instead")
        case .None(let error):
            XCTAssert(error == error)
        }
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
        assertError(tokens: inputTokens, error: RuleError.UnexpectedValue)
    }

    func testUnexpectedTokenCount() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedTokenCount)
    }

    func testUnexpectedTokenType() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.parameterSeparator]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedTokenType)
    }
    
    func testIncorrectSeparator() {
        let inputTokens = [Token.identifier("BEGIN"), Token.parameterSeparator, Token.identifier("VCALENDAR")]
        assertError(tokens: inputTokens, error: RuleError.IncorrectSeparator)
    }

    func testUnexpectedName() {
        let inputTokens = [Token.identifier("BOGUS"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        assertError(tokens: inputTokens, error: RuleError.UnexpectedName)
    }
}
