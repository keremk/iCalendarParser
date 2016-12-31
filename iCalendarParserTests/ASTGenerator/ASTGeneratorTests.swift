//
//  ASTGeneratorTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ASTGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
    func testOneLevelDeepComponent() {
        // BEGIN:VCALENDAR
        // VERSION:2.0
        // END:VCALENDAR
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR"), Token.contentLine,   Token.identifier("VERSION"), Token.valueSeparator, Token.identifier("2.0"), Token.contentLine,
            Token.identifier("END"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        
        var generator = ASTGenerator()
        let resultNode = generator.generate(tokens: inputTokens) as! Node<Component>
       
        let expectedNodeValue = Component.calendar
        XCTAssert(resultNode.value == expectedNodeValue)
        XCTAssert(resultNode.name == ElementName.begin)

        XCTAssertNil(resultNode.parent)

        let children = resultNode.children
        XCTAssert(children.count == 1)
        let propertyNode = children[0] as! Node<String>

        let expectedPropertyValue = "2.0"
        XCTAssert(propertyNode.value == expectedPropertyValue)
        XCTAssert(propertyNode.name == ElementName.version)
    }
    
    func testTwoLevelsDeepComponent() {
        // BEGIN:VCALENDAR
        // VERSION:2.0
        // BEGIN:VEVENT
        // SUMMARY:Networld+Interop Conference
        // END:VEVENT
        // END:VCALENDAR
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR"), Token.contentLine, Token.identifier("VERSION"), Token.valueSeparator, Token.identifier("2.0"), Token.contentLine,
            Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VEVENT"), Token.contentLine,
            Token.identifier("SUMMARY"), Token.valueSeparator, Token.identifier("Networld+Interop Conference"), Token.contentLine,
            Token.identifier("END"), Token.valueSeparator, Token.identifier("VEVENT"), Token.contentLine,
            Token.identifier("END"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        
        var generator = ASTGenerator()
        let resultNode = generator.generate(tokens: inputTokens) as! Node<Component>

        let children = resultNode.children
        XCTAssert(children.count == 2)
        
        // Check Version Value
        let versionNode = children[0] as! Node<String>
        XCTAssertNotNil(versionNode.parent)
        XCTAssert(versionNode.value == "2.0")
        
        // Check Event Component
        let eventNode = children[1] as! Node<Component>
        XCTAssertNotNil(eventNode.parent)
        XCTAssert(eventNode.value == .event)
        XCTAssert(eventNode.name == .begin)
        
        // Check Summary Value
        let eventNodeChildren = eventNode.children
        XCTAssert(eventNodeChildren.count == 1)
        let summaryNode = eventNodeChildren[0] as! Node<String>
        XCTAssertNotNil(summaryNode.parent)
        XCTAssert(summaryNode.value == "Networld+Interop Conference")
        XCTAssert(summaryNode.name == .summary)
    }
    
    
    func testPropertyWithParams() {
        // BEGIN:VCALENDAR
        // BEGIN:VEVENT
        // ATTENDEE;RSVP=TRUE;CUTYPE=GROUP:mailto:employee-A@example.com
        // END:VEVENT
        // END:VCALENDAR
        let inputTokens = [Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VCALENDAR"), Token.contentLine,
                           Token.identifier("BEGIN"), Token.valueSeparator, Token.identifier("VEVENT"), Token.contentLine,
                           Token.identifier("ATTENDEE"), Token.parameterSeparator,
                           Token.identifier("RSVP"), Token.parameterValueSeparator, Token.identifier("TRUE"), Token.parameterSeparator,
                           Token.identifier("CUTYPE"), Token.parameterValueSeparator, Token.identifier("GROUP"), Token.valueSeparator,
                           Token.identifier("mailto:employee-A@example.com"), Token.contentLine,
                           Token.identifier("END"), Token.valueSeparator, Token.identifier("VEVENT"), Token.contentLine,
                           Token.identifier("END"), Token.valueSeparator, Token.identifier("VCALENDAR")]
        
        var generator = ASTGenerator()
        let resultNode = generator.generate(tokens: inputTokens) as! Node<Component>
        
        let children = resultNode.children
        XCTAssert(children.count == 1)
       
        // Check Attendee Property
        let eventNode = children[0] as! Node<Component>
        let eventNodeChildren = eventNode.children
        XCTAssert(eventNodeChildren.count == 1)
        let attendeeNode = eventNodeChildren[0] as! Node<String>
        XCTAssert(attendeeNode.value == "mailto:employee-A@example.com")
        XCTAssert(attendeeNode.name == .attendee)
        
        // Check RSVP parameter
        let attendeeChildren = attendeeNode.children
        XCTAssert(attendeeChildren.count == 2)
        let rsvpParameter = attendeeChildren[0] as! Node<Bool>
        XCTAssert(rsvpParameter.value == true)
        XCTAssert(rsvpParameter.name == .rsvp)

        // Check CUType parameter
        let cuTypeParameter = attendeeChildren[1] as! Node<String>
        XCTAssert(cuTypeParameter.value == "GROUP")
        XCTAssert(cuTypeParameter.name == .cutype)
    }
    
}
