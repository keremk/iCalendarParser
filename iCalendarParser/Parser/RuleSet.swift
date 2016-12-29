//
//  RuleSet.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/28/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

struct RuleSet {
    static let rules:[ElementName:Rule] = [
        .begin: DefaultRule(valueMapper: AnyValueMapper(ComponentMapper()), nodeType: .container),
        .end: DefaultRule(valueMapper: AnyValueMapper(ComponentMapper()), nodeType: .container),
        .version: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .summary: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .attendee: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .description: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .categories: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property, isMultiValued: true),
        .altRep: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter, separator: Token.parameterValueSeparator),
        .rsvp: DefaultRule(valueMapper: AnyValueMapper(BooleanMapper()), nodeType: .parameter, separator: Token.parameterValueSeparator),
        .cutype: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter, separator: Token.parameterValueSeparator)
    ]
}
