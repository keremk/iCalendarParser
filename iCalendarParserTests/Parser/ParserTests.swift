//
//  ParserTests.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import XCTest

class ParserTests: XCTestCase {
    
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
        
        var parser = Parser()
        let resultNode = parser.parse(tokens: inputTokens) as! Node<ComponentValueType>
       
        let expectedNodeValue = NodeValue<ComponentValueType>.Component(.Calendar, .Begin)
        XCTAssert(resultNode.nodeValue == expectedNodeValue)

        XCTAssertNil(resultNode.parent)

        let children = resultNode.children
        XCTAssert(children.count == 1)
        let propertyNode = children[0] as! Node<String>

        let expectedPropertyValue = NodeValue<String>.Property(.Version, "2.0")
        XCTAssert(propertyNode.nodeValue == expectedPropertyValue)
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
        
        var parser = Parser()
        let resultNode = parser.parse(tokens: inputTokens) as! Node<ComponentValueType>

        let children = resultNode.children
        XCTAssert(children.count == 2)
        
        // Check Version Value
        let versionNode = children[0] as! Node<String>
        XCTAssertNotNil(versionNode.parent)
        let expectedVersionNodeValue = NodeValue<String>.Property(.Version, "2.0")
        XCTAssert(versionNode.nodeValue == expectedVersionNodeValue)
        
        // Check Event Component
        let eventNode = children[1] as! Node<ComponentValueType>
        XCTAssertNotNil(eventNode.parent)
        let expectedEventNodeValue = NodeValue<ComponentValueType>.Component(.Event, .Begin)
        XCTAssert(eventNode.nodeValue == expectedEventNodeValue)
        
        // Check Summary Value
        let eventNodeChildren = eventNode.children
        XCTAssert(eventNodeChildren.count == 1)
        let summaryNode = eventNodeChildren[0] as! Node<String>
        XCTAssertNotNil(summaryNode.parent)
        let expectedSummaryNodeValue = NodeValue<String>.Property(.Summary, "Networld+Interop Conference")
        XCTAssert(summaryNode.nodeValue == expectedSummaryNodeValue)
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
        
        var parser = Parser()
        let resultNode = parser.parse(tokens: inputTokens) as! Node<ComponentValueType>
        
        let children = resultNode.children
        XCTAssert(children.count == 1)
       
        // Check Attendee Property
        let eventNode = children[0] as! Node<ComponentValueType>
        let eventNodeChildren = eventNode.children
        XCTAssert(eventNodeChildren.count == 1)
        let attendeeNode = eventNodeChildren[0] as! Node<String>
        XCTAssert(attendeeNode.nodeValue == NodeValue.Property(PropertyName.Attendee, "mailto:employee-A@example.com"))
        
        // Check RSVP parameter
        let attendeeChildren = attendeeNode.children
        XCTAssert(attendeeChildren.count == 2)
        let rsvpParameter = attendeeChildren[0] as! Node<String>
        XCTAssert(rsvpParameter.nodeValue == NodeValue.Parameter(ParameterName.Rsvp, "TRUE"))

        // Check CUType parameter
        let cuTypeParameter = attendeeChildren[1] as! Node<String>
        XCTAssert(cuTypeParameter.nodeValue == NodeValue.Parameter(ParameterName.Cutype, "GROUP"))
    }
    
}
