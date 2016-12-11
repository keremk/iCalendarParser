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
    internal func invokeRule(tokens: [Token]) -> RuleOutput {
        guard tokens.count >= 3 else {
            return RuleOutput.None(RuleError.UnexpectedTokenCount)
        }
        guard tokens[1] == Token.valueSeparator else {
            return RuleOutput.None(RuleError.IncorrectSeparator)
        }
        
        var ruleOutput:RuleOutput
        switch (tokens[0], tokens[2]) {
        case (.identifier(let name), .identifier(let value)):
            ruleOutput = createNode(name: name, value: value)
            break
        default:
            ruleOutput = RuleOutput.None(RuleError.UnexpectedTokenType)
            break
        }
        
        return ruleOutput
    }
    
    private func createNode(name:String, value:String) -> RuleOutput {
        guard let componentEntry = ComponentIndicator(rawValue: name) else {
            return RuleOutput.None(RuleError.UnexpectedName)
        }
        guard let componentType = ComponentType(rawValue: value) else {
            return RuleOutput.None(RuleError.UnexpectedValue)
        }
        
        var ruleOutput:RuleOutput
        switch componentEntry {
        case .Begin:
            let nodeValue = NodeValue<ComponentValueType>.Component(componentType, ComponentIndicator.Begin)
            let node = Node(nodeValue: nodeValue)
            ruleOutput = RuleOutput.Node(node)
            break
        case .End:
            let nodeValue = NodeValue<ComponentValueType>.Component(componentType, ComponentIndicator.End)
            let node = Node(nodeValue: nodeValue)
            ruleOutput = RuleOutput.Node(node)
            break
        }
        return ruleOutput
    }
}
