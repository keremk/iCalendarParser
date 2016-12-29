//
//  DefaultRuleTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/29/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class DefaultRuleTests: XCTestCase, Assertable {
    // MARK: Setup/Teardown
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Helpers
    func componentRule() -> DefaultRule<Component> {
        return DefaultRule(valueMapper: AnyValueMapper(ComponentMapper()), nodeType: .container)
    }
    
    func propertyRule() -> DefaultRule<String> {
        return DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property)
    }
    
    func parameterRule() -> DefaultRule<Bool> {
        return DefaultRule(valueMapper: AnyValueMapper(BooleanMapper()), nodeType: .parameter, separator: Token.parameterValueSeparator)
    }
    
    // MARK: Component Rules
    func testExistingRuleWithEnd() {
        let inputTokens = [Token.identifier("END"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        let expectedNode = Node<Component>(name: .end, value: .calendar, type: .container)
        let result = componentRule().invokeRule(tokens: inputTokens)
        assertNode(node: result.unwrap() as! Node<Component>?, expectedNode: expectedNode)
    }
    
    // MARK: Property Rules
    func testSimpleNameValueProperty() {
        let inputTokens = [Token.identifier("SUMMARY"), Token.valueSeparator, Token.identifier("This is a summary")]
        let expectedNode = Node<String>(name: .summary, value: "This is a summary", type: .property)
        let result = propertyRule().invokeRule(tokens: inputTokens)
        assertNode(node: result.unwrap() as! Node<String>?, expectedNode: expectedNode)
    }

    func testMultiValueProperty() {
        let inputTokens = [Token.identifier("CATEGORIES"), Token.valueSeparator, Token.identifier("EDUCATION"), Token.multiValueSeparator, Token.identifier("BUSINESS")]
        let expectedNode = Node<MultiValued<String>>(name: .categories, value: MultiValued(values: ["EDUCATION", "BUSINESS"]), type: .property)
        let result = DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property, isMultiValued: true).invokeRule(tokens: inputTokens)
        assertNode(node: result.unwrap() as! Node<MultiValued<String>>?, expectedNode: expectedNode)
    }

    // MARK: Parameter Rules
    func testSimpleNameValueParameter() {
        let inputTokens = [Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE")]
        let expectedNode = Node<Bool>(name: .rsvp, value: true, type: .parameter)
        let result = parameterRule().invokeRule(tokens: inputTokens)
        assertNode(node: result.unwrap() as! Node<Bool>?, expectedNode: expectedNode)
    }

    // MARK: Error cases
    func testUnexpectedTokenValue() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("BOGUS")]
        let result = componentRule().invokeRule(tokens: inputTokens)
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)
    }
    
    func testUnexpectedTokenCount() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator]
        let result = componentRule().invokeRule(tokens: inputTokens)
        assertFailure(result: result, expectedError: RuleError.UnexpectedTokenCount)
    }
    
    func testUnexpectedTokenType() {
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.parameterSeparator]
        let result = componentRule().invokeRule(tokens: inputTokens)
        assertFailure(result: result, expectedError: RuleError.UnexpectedTokenType)
    }
    
    func testIncorrectSeparator() {
        let inputTokens = [Token.identifier("BEGIN"), Token.parameterSeparator, Token.identifier("VCALENDAR")]
        let result = componentRule().invokeRule(tokens: inputTokens)
        assertFailure(result: result, expectedError: RuleError.IncorrectSeparator)
    }
    
    func testUnexpectedName() {
        let inputTokens = [Token.identifier("BOGUS"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        let result = componentRule().invokeRule(tokens: inputTokens)
        assertFailure(result: result, expectedError: RuleError.UnexpectedName)
    }
}
