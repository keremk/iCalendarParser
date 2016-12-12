//
//  TokenHelperTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/12/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class TokenHelperTests: XCTestCase {
    
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
        let expectedTokens = [[Token.identifier("ORGANIZER"), Token.valueSeparator, Token.identifier("mailto:mrbig@example.com")], []]
        
        let output = TokenHelper.extractParameterTokens(tokens: inputTokens)
        XCTAssert(output[0] == expectedTokens[0])
        XCTAssert(output[1] == expectedTokens[1])
    }
    
    func testPropertyWithParametersTokenList() {
        // ATTENDEE;RSVP=TRUE;ROLE=REQ-PARTICIPANT;CUTYPE=GROUP:mailto:employee-A@example.com
        let inputTokens = [Token.identifier("ATTENDEE"), Token.parameterSeparator,
                           Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE"), Token.parameterSeparator,
                           Token.identifier("ROLE"), Token.parameterValueSeparator, Token.identifier("REQ-PARTICIPANT"), Token.parameterSeparator,
                           Token.identifier("CUTYPE"), Token.parameterValueSeparator, Token.identifier("GROUP"), Token.valueSeparator,
                           Token.identifier("mailto:employee-A@example.com")]
        let expectedTokens = [[Token.identifier("ATTENDEE"), Token.valueSeparator, Token.identifier("mailto:employee-A@example.com")],
                              [Token.parameterSeparator,
                               Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE"), Token.parameterSeparator,
                               Token.identifier("ROLE"), Token.parameterValueSeparator, Token.identifier("REQ-PARTICIPANT"), Token.parameterSeparator,
                               Token.identifier("CUTYPE"), Token.parameterValueSeparator, Token.identifier("GROUP")]]
        
        let output = TokenHelper.extractParameterTokens(tokens: inputTokens)
        XCTAssert(output[0] == expectedTokens[0])
        XCTAssert(output[1] == expectedTokens[1])
    }
}
