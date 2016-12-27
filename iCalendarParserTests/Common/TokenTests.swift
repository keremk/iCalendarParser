//
//  TokenTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/17/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class TokenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSplitTokensWithParameterValues() {
        // RRULE:FREQ=YEARLY;BYHOUR=8,9;BYMINUTE=30
        let inputTokens = [Token.identifier("RRULE"), Token.valueSeparator,
                           Token.identifier("FREQ"), Token.parameterValueSeparator, Token.identifier("YEARLY"), Token.parameterSeparator,
                           Token.identifier("BYHOUR"), Token.parameterValueSeparator, Token.identifier("8"), Token.multiValueSeparator, Token.identifier("9"), Token.parameterSeparator,
                           Token.identifier("BYMINUTE"), Token.parameterValueSeparator, Token.identifier("30")]
        let expectedTokens = [[Token.identifier("RRULE")],
                              [Token.identifier("FREQ"), Token.parameterValueSeparator, Token.identifier("YEARLY"), Token.parameterSeparator,
                               Token.identifier("BYHOUR"), Token.parameterValueSeparator, Token.identifier("8"), Token.multiValueSeparator, Token.identifier("9"), Token.parameterSeparator,
                               Token.identifier("BYMINUTE"), Token.parameterValueSeparator, Token.identifier("30")]]
        
        let output = inputTokens.splitTokens(by: Token.valueSeparator)
        for (index, tokens) in output.enumerated() {
            XCTAssert(tokens == expectedTokens[index])
        }
    }
    
    func testSplitTokensWithParameters() {
        // ATTENDEE;RSVP=TRUE;CUTYPE=GROUP:mailto:employee-A@example.com
        let inputTokens = [Token.identifier("ATTENDEE"), Token.parameterSeparator,
                           Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE"), Token.parameterSeparator,
                           Token.identifier("CUTYPE"), Token.parameterValueSeparator, Token.identifier("GROUP"), Token.valueSeparator,
                           Token.identifier("mailto:employee-A@example.com")]
        let expectedTokens = [[Token.identifier("ATTENDEE"), Token.parameterSeparator,
                               Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE"), Token.parameterSeparator,
                               Token.identifier("CUTYPE"), Token.parameterValueSeparator, Token.identifier("GROUP")],
                              [Token.identifier("mailto:employee-A@example.com")]]
        
        let output = inputTokens.splitTokens(by: Token.valueSeparator)
        for (index, tokens) in output.enumerated() {
            XCTAssert(tokens == expectedTokens[index])
        }
        
    }
    
    func testSplitTokensWithParameterSeparator() {
        let inputTokens = [Token.identifier("FREQ"), Token.parameterValueSeparator, Token.identifier("YEARLY"), Token.parameterSeparator,
                           Token.identifier("BYHOUR"), Token.parameterValueSeparator, Token.identifier("8"), Token.multiValueSeparator, Token.identifier("9"), Token.parameterSeparator,
                           Token.identifier("BYMINUTE"), Token.parameterValueSeparator, Token.identifier("30")]
        let expectedTokens = [[Token.identifier("FREQ"), Token.parameterValueSeparator, Token.identifier("YEARLY")],
                              [Token.identifier("BYHOUR"), Token.parameterValueSeparator, Token.identifier("8"), Token.multiValueSeparator, Token.identifier("9")],
                              [Token.identifier("BYMINUTE"), Token.parameterValueSeparator, Token.identifier("30")]]
        
        let output = inputTokens.splitTokens(by: Token.parameterSeparator)
        for (index, tokens) in output.enumerated() {
            XCTAssert(tokens == expectedTokens[index])
        }
    }

    
    func testPropertyOnlyTokenList() {
        // ORGANIZER:mailto:mrbig@example.com
        let inputTokens = [Token.identifier("ORGANIZER"), Token.valueSeparator, Token.identifier("mailto:mrbig@example.com")]
        let expectedTokens = [[Token.identifier("ORGANIZER"), Token.valueSeparator, Token.identifier("mailto:mrbig@example.com")]]
        
        let output = inputTokens.groupTokens()
        XCTAssert(output[0] == expectedTokens[0])
    }
    
    func testMultiValueProperty() {
        // CATEGORIES:APPOINTMENT,EDUCATION
        let inputTokens = [Token.identifier("CATEGORIES"), Token.valueSeparator, Token.identifier("APPOINTMENT"), Token.multiValueSeparator, Token.identifier("EDUCATION")]
        let expectedTokens = [[Token.identifier("CATEGORIES"), Token.valueSeparator, Token.identifier("APPOINTMENT"), Token.multiValueSeparator, Token.identifier("EDUCATION")]]
        
        let output = inputTokens.groupTokens()
        XCTAssert(output[0] == expectedTokens[0])
    }
    
    func testGroupTokensWithParameters() {
        // ATTENDEE;RSVP=TRUE;CUTYPE=GROUP:mailto:employee-A@example.com
        let inputTokens = [Token.identifier("ATTENDEE"), Token.parameterSeparator,
                           Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE"), Token.parameterSeparator,
                           Token.identifier("CUTYPE"), Token.parameterValueSeparator, Token.identifier("GROUP"), Token.valueSeparator,
                           Token.identifier("mailto:employee-A@example.com")]
        let expectedTokens = [[Token.identifier("ATTENDEE"), Token.valueSeparator, Token.identifier("mailto:employee-A@example.com")],
                              [Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE")],
                              [Token.identifier("CUTYPE"), Token.parameterValueSeparator, Token.identifier("GROUP")]]
        
        let output = inputTokens.groupTokens()
        for (index, tokens) in output.enumerated() {
            XCTAssert(tokens == expectedTokens[index])
        }
    }
    
    func testGroupTokensWithParametersInValue() {
        // RRULE:FREQ=YEARLY;BYHOUR=8,9;BYMINUTE=30
        let inputTokens = [Token.identifier("RRULE"), Token.valueSeparator,
                           Token.identifier("FREQ"), Token.parameterValueSeparator, Token.identifier("YEARLY"), Token.parameterSeparator,
                           Token.identifier("BYHOUR"), Token.parameterValueSeparator, Token.identifier("8"), Token.multiValueSeparator, Token.identifier("9"), Token.parameterSeparator,
                           Token.identifier("BYMINUTE"), Token.parameterValueSeparator, Token.identifier("30")]
        let expectedTokens = [[Token.identifier("RRULE"), Token.valueSeparator, Token.identifier("")],
                              [Token.identifier("FREQ"), Token.parameterValueSeparator, Token.identifier("YEARLY")],
                              [Token.identifier("BYHOUR"), Token.parameterValueSeparator, Token.identifier("8"), Token.multiValueSeparator, Token.identifier("9")],
                              [Token.identifier("BYMINUTE"), Token.parameterValueSeparator, Token.identifier("30")]]
        
        let output = inputTokens.groupTokens()
        for (index, tokens) in output.enumerated() {
            XCTAssert(tokens == expectedTokens[index])
        }
    }    
}
