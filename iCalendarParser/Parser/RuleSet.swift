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
        .altRep: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .cutype: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .cn: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .delegatedFrom: DefaultRule(valueMapper: AnyValueMapper(CalendarUserAddressMapper()), nodeType: .parameter),
        .delegatedTo: DefaultRule(valueMapper: AnyValueMapper(CalendarUserAddressMapper()), nodeType: .parameter, isMultiValued: true),
        .dir: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .formatType: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .freeBusyType: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .language: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .member: DefaultRule(valueMapper: AnyValueMapper(CalendarUserAddressMapper()), nodeType: .parameter),
        .participationStatus: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .range: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .related: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .relType: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .role: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .rsvp: DefaultRule(valueMapper: AnyValueMapper(BooleanMapper()), nodeType: .parameter),
        .sentBy: DefaultRule(valueMapper: AnyValueMapper(CalendarUserAddressMapper()), nodeType: .parameter),
        .tzid: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter),
        .value: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .parameter)
    ]
}
