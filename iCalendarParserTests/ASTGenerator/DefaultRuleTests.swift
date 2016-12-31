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
        return DefaultRule(valueMapper: AnyValueMapper(BooleanMapper()), nodeType: .parameter)
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
    
    func testMultiValuedPeriodOfTimeProperty() {
        let inputTokens = [Token.identifier("FREEBUSY"), Token.valueSeparator, Token.identifier("19970308T160000Z/PT3H"), Token.multiValueSeparator, Token.identifier("19970308T230000Z/19970309T000000Z")]
        
        let startDate1 = dateFrom(year: 1997, month: 3, day: 8, hour: 16, minute: 0, second: 0, timeZone: TimeZone(secondsFromGMT: 0)!)
        let duration1 = Duration(isNegative: false, days: nil, weeks: nil, hours: 3, minutes: nil, seconds: nil)
        let periodOfTime1 = PeriodOfTime(start: startDate1, period: PeriodIndicator.duration(duration1))
        
        let startDate2 = dateFrom(year: 1997, month: 3, day: 8, hour: 23, minute: 0, second: 0, timeZone: TimeZone(secondsFromGMT: 0)!)
        let endDate2 = dateFrom(year: 1997, month: 3, day: 9, hour: 0, minute: 0, second: 0, timeZone: TimeZone(secondsFromGMT: 0)!)
        let periodOfTime2 = PeriodOfTime(start: startDate2, period: PeriodIndicator.endDate(endDate2))

        let expectedNode = Node<MultiValued<PeriodOfTime>>(name: .freeBusy, value: MultiValued(values: [periodOfTime1, periodOfTime2]), type: .property)
        let result = DefaultRule(valueMapper: AnyValueMapper(PeriodofTimeMapper()), nodeType: .property, isMultiValued: true).invokeRule(tokens: inputTokens)
        assertNode(node: result.unwrap() as! Node<MultiValued<PeriodOfTime>>?, expectedNode: expectedNode)
    }
    
    func testValueSeparatedBySemiColon() {
        let inputTokens = [Token.identifier("GEO"), Token.valueSeparator, Token.identifier("37.386013"), Token.parameterSeparator, Token.identifier("-122.082932")]
        let expectedNode = Node<MultiValued<Float>>(name: .geo, value: MultiValued(values: [37.386013, -122.082932]), type: .property)
        let result = DefaultRule(valueMapper: AnyValueMapper(FloatMapper()), nodeType: .property, isMultiValued: true, multiValueSeparator: Token.parameterSeparator).invokeRule(tokens: inputTokens)
        assertNode(node: result.unwrap() as! Node<MultiValued<Float>>?, expectedNode: expectedNode)
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
