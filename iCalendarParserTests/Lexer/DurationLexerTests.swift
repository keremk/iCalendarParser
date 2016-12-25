//
//  DurationLexerTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class DurationLexerTests: XCTestCase, Assertable {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertSuccess(result: Result<[Token], RuleError>, expectedTokens: [Token]) {
        if case .success(let value) = result {
            XCTAssert(value == expectedTokens)
        } else {
            XCTFail("Unexpected Failure")
        }
    }
    
    func testPositiveDuration() {
        let expectedTokens = [Token.duration, Token.identifier("1"), Token.day, Token.time, Token.identifier("12"), Token.hour, Token.identifier("5"), Token.minute]
        var durationLexer = DurationLexer(input: "P1DT12H5M")
        let result = durationLexer.scan()
        assertSuccess(result: result, expectedTokens: expectedTokens)
    }
    
    func testNegativeDuration() {
        let expectedTokens = [Token.minus, Token.duration, Token.identifier("1"), Token.week]
        var durationLexer = DurationLexer(input: "-P1W")
        let result = durationLexer.scan()
        assertSuccess(result: result, expectedTokens: expectedTokens)
    }
    
    func testIncorrectValuesInDuration() {
        var durationLexer = DurationLexer(input: "PaW")
        let result = durationLexer.scan()
        assertFailure(result: result, expectedError: RuleError.UnexpectedValue)        
    }
}
