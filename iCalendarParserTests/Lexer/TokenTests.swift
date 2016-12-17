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
    
    func testPropertyOnlyTokenList() {
        // ORGANIZER:mailto:mrbig@example.com
        let inputTokens = [Token.identifier("ORGANIZER"), Token.valueSeparator, Token.identifier("mailto:mrbig@example.com")]
        let expectedTokens = [[Token.identifier("ORGANIZER"), Token.valueSeparator, Token.identifier("mailto:mrbig@example.com")]]
        
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

    
}
