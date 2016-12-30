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
        // MARK: Components
        .begin: DefaultRule(valueMapper: AnyValueMapper(ComponentMapper()), nodeType: .container),
        .end: DefaultRule(valueMapper: AnyValueMapper(ComponentMapper()), nodeType: .container),
        // MARK: Calendar Properties
        .calScale: DefaultRule(valueMapper:  AnyValueMapper(TextMapper()), nodeType: .property),
        .method: DefaultRule(valueMapper:  AnyValueMapper(TextMapper()), nodeType: .property),
        .prodId:DefaultRule(valueMapper:  AnyValueMapper(TextMapper()), nodeType: .property),
        .version: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        // MARK: Descriptive Component Properties
        .attach: DefaultRule(valueMapper: AnyValueMapper(UriMapper()), nodeType: .property),
        .categories: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property, isMultiValued: true),
        .classification: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .comment:  DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .description: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .geo: DefaultRule(valueMapper: AnyValueMapper(FloatMapper()), nodeType: .property, isMultiValued: true, multiValueSeparator: Token.parameterSeparator),
        .location: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .percentComplete: DefaultRule(valueMapper: AnyValueMapper(IntegerMapper()), nodeType: .property),
        .priority:  DefaultRule(valueMapper: AnyValueMapper(IntegerMapper()), nodeType: .property),
        .resources: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property, isMultiValued: true),
        .status: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .summary: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),        
        // MARK: Date and Time Component Properties
        .completed: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .dtend: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .due: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .dtstart: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .duration: DefaultRule(valueMapper: AnyValueMapper(DurationMapper()), nodeType: .property),
        .freeBusy: DefaultRule(valueMapper: AnyValueMapper(PeriodofTimeMapper()), nodeType: .property, isMultiValued: true),
        .transparency: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        // MARK: Timezone Component Properties
        .tzName: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .tzOffsetFrom: DefaultRule(valueMapper: AnyValueMapper(UTCOffsetMapper()), nodeType: .property),
        .tzOffsetTo: DefaultRule(valueMapper: AnyValueMapper(UTCOffsetMapper()), nodeType: .property),
        .tzUrl: DefaultRule(valueMapper: AnyValueMapper(UriMapper()), nodeType: .property),
        // MARK: Relationship Component Properties
        .attendee: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .contact: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .organizer: DefaultRule(valueMapper: AnyValueMapper(CalendarUserAddressMapper()), nodeType: .property),
        .recurrenceId: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .relatedTo: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .url: DefaultRule(valueMapper: AnyValueMapper(UriMapper()), nodeType: .property),
        .uid: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        // MARK: Recurrence Component Properties
        .exDate: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property, isMultiValued: true),
        // MARK: Alarm Component Properties
        .action: DefaultRule(valueMapper: AnyValueMapper(TextMapper()), nodeType: .property),
        .repeatCount: DefaultRule(valueMapper: AnyValueMapper(IntegerMapper()), nodeType: .property),
        // MARK: Change Management Component Properties
        .created: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .dtStamp: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .lastModified: DefaultRule(valueMapper: AnyValueMapper(DateTimeMapper()), nodeType: .property),
        .sequence: DefaultRule(valueMapper: AnyValueMapper(IntegerMapper()), nodeType: .property),
        // MARK: Misc Component Properties
        // MARK: Parameters
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
