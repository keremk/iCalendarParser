//
//  iCalendarLexerTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 11/13/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class iCalendarLexerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimpleInput() {
        let input = "ORGANIZER:mailto:jsmith@example.com"
        var scanner = Scanner(input: input)
        
        let tokens = scanner.scan()
        let expectedTokens = [Token.identifier("ORGANIZER"), Token.valueSeparator, Token.identifier("mailto:jsmith@example.com") ]
        
        XCTAssertEqual(tokens, expectedTokens)
    }
    
    func testPropertyParameters() {
        let input = "DTSTART;TZID=America/New_York:19980312T083000"
        var scanner = Scanner(input: input)
        
        let tokens = scanner.scan()
        let expectedTokens = [Token.identifier("DTSTART"), Token.parameterSeparator, Token.identifier("TZID"), Token.parameterValueSeparator, Token.identifier("America/New_York"), Token.valueSeparator, Token.identifier("19980312T083000") ]
        
        XCTAssertEqual(tokens, expectedTokens)
    }
    
    func testContentLines() {
        let input = "BEGIN:VCALENDAR" + "\r\n" + "PRODID:-//RDU Software//NONSGML HandCal//EN"
        var scanner = Scanner(input: input)
        
        let tokens = scanner.scan()
        let expectedTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR"), Token.contentLine, Token.identifier("PRODID"), Token.valueSeparator, Token.identifier("-//RDU Software//NONSGML HandCal//EN") ]
        
        XCTAssertEqual(tokens, expectedTokens)
    }
    
    func testFoldedLine() {
        let input = "DESCRIPTION:Project xyz Review Meeting Minutes" + "\r\n" + "  Foobar is important" + "\r\n" + "END:VEVENT"
        var scanner = Scanner(input: input)

        let tokens = scanner.scan()
        let expectedTokens = [Token.identifier("DESCRIPTION"), Token.valueSeparator, Token.identifier("Project xyz Review Meeting Minutes Foobar is important"), Token.contentLine, Token.identifier("END"), Token.valueSeparator, Token.identifier("VEVENT") ]
        
        XCTAssertEqual(tokens, expectedTokens)
    }
    
    func testMultiValues() {
        let input = "CATEGORIES:MEETING,PROJECT"
        var scanner = Scanner(input: input)
        
        let tokens = scanner.scan()
        let expectedTokens = [Token.identifier("CATEGORIES"), Token.valueSeparator, Token.identifier("MEETING"), Token.multiValueSeparator, Token.identifier("PROJECT") ]
        
        XCTAssertEqual(tokens, expectedTokens)
    }
    
    func testMultipleContentLines() {
        let input = "DESCRIPTION:Project xyz Review Meeting Minutes" + "\r\n" + "  Foobar is\n important" + "\r\n\r\n" + "END:VEVENT"
        var scanner = Scanner(input: input)
        
        let tokens = scanner.scan()
        let expectedTokens = [Token.identifier("DESCRIPTION"), Token.valueSeparator, Token.identifier("Project xyz Review Meeting Minutes Foobar is\n important"), Token.contentLine, Token.contentLine, Token.identifier("END"), Token.valueSeparator, Token.identifier("VEVENT") ]
        
        XCTAssertEqual(tokens, expectedTokens)
    }
}
