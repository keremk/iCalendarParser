//
//  DurationLexerTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/23/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class DurationLexerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPositiveDuration() {
        let durationString = "P1DT12H5M"
        let expectedTokens = [Token.duration, Token.identifier("1"), Token.day, Token.time, Token.identifier("12"), Token.hour, Token.identifier("5"), Token.minute]
        
        var durationLexer = DurationLexer(input: durationString)
        let tokens = durationLexer.scan()
        
        XCTAssert(tokens == expectedTokens)
    }
    
    func testNegativeDuration() {
        let durationString = "-P1W"
        let expectedTokens = [Token.minus, Token.duration, Token.identifier("1"), Token.week]
        
        var durationLexer = DurationLexer(input: durationString)
        let tokens = durationLexer.scan()
        XCTAssert(tokens == expectedTokens)
    }
    
    func testIncorrectValuesInDuration() {
        // TODO: We should not fail silently like this 
        let durationString = "PaW"
        let expectedTokens = [Token.duration, Token.week]
        
        var durationLexer = DurationLexer(input: durationString)
        let tokens = durationLexer.scan()
        XCTAssert(tokens == expectedTokens)        
    }
}
