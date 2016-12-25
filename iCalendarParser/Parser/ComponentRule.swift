//
//  ComponentRule.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/10/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

enum ComponentIndicator: String, RawRepresentable {
    case Begin = "BEGIN"
    case End = "END"
}

enum ComponentType: String, RawRepresentable {
    case Calendar = "VCALENDAR"
    case Event = "VEVENT"
    case ToDo = "VTODO"
    case Journal = "VJOURNAL"
    case FreeBusy = "VFREEBUSY"
    case TimeZone = "VTIMEZONE"
    case Alarm = "VALARM"
}

struct ComponentRule: Rule {
    internal func invokeRule(tokens: [Token]) -> Result<Parsable, RuleError> {
        guard tokens.count >= 3 else {
            return .failure(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == Token.valueSeparator else {
            return .failure(RuleError.IncorrectSeparator)
        }
        
        var ruleOutput:Result<Parsable, RuleError>
        switch (tokens[0], tokens[2]) {
        case (.identifier(let name), .identifier(let value)):
            ruleOutput = createNode(name: name, value: value)
            break
        default:
            ruleOutput = .failure(RuleError.UnexpectedTokenType)
            break
        }
        
        return ruleOutput
    }
    
    private func createNode(name:String, value:String) -> Result<Parsable, RuleError> {
        guard let componentEntry = ComponentIndicator(rawValue: name) else {
            return .failure(RuleError.UnexpectedName)
        }
        guard let componentType = ComponentType(rawValue: value) else {
            return .failure(RuleError.UnexpectedValue)
        }
        
        var ruleOutput:Result<Parsable, RuleError>
        switch componentEntry {
        case .Begin:
            let nodeValue = NodeValue<ComponentValueType>.Component(componentType, ComponentIndicator.Begin)
            let node = Node(nodeValue: nodeValue)
            ruleOutput = .success(node)
            break
        case .End:
            let nodeValue = NodeValue<ComponentValueType>.Component(componentType, ComponentIndicator.End)
            let node = Node(nodeValue: nodeValue)
            ruleOutput = .success(node)
            break
        }
        return ruleOutput
    }
}
