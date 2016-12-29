//
//  ElementName.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/28/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

enum ElementName: String, RawRepresentable {
    // MARK: Components
    case begin = "BEGIN"
    case end = "END"
    // MARK: Properties
    case version = "VERSION"
    case description = "DESCRIPTION"
    case summary = "SUMMARY"
    case attendee = "ATTENDEE"
    case categories = "CATEGORIES"
    // MARK: Parameters
    case altRep = "ALTREP" // https://icalendar.org/iCalendar-RFC-5545/3-2-1-alternate-text-representation.html
    case cutype = "CUTYPE" // https://icalendar.org/iCalendar-RFC-5545/3-2-3-calendar-user-type.html
    case cn = "CN" // https://icalendar.org/iCalendar-RFC-5545/3-2-2-common-name.html
    case delegatedFrom = "DELEGATED-FROM" // https://icalendar.org/iCalendar-RFC-5545/3-2-4-delegators.html
    case delegatedTo = "DELEGATED-TO" // https://icalendar.org/iCalendar-RFC-5545/3-2-5-delegatees.html
    case dir = "DIR"  // https://icalendar.org/iCalendar-RFC-5545/3-2-6-directory-entry-reference.html
    case formatType = "FMTTYPE" // https://icalendar.org/iCalendar-RFC-5545/3-2-8-format-type.html
    case freeBusyType = "FBTYPE" // https://icalendar.org/iCalendar-RFC-5545/3-2-9-free-busy-time-type.html
    case language = "LANGUAGE" // https://icalendar.org/iCalendar-RFC-5545/3-2-10-language.html
    case member = "MEMBER" // https://icalendar.org/iCalendar-RFC-5545/3-2-11-group-or-list-membership.html
    case participationStatus = "PARTSTAT" // https://icalendar.org/iCalendar-RFC-5545/3-2-12-participation-status.html
    case range = "RANGE" // https://icalendar.org/iCalendar-RFC-5545/3-2-13-recurrence-identifier-range.html
    case related = "RELATED" // https://icalendar.org/iCalendar-RFC-5545/3-2-14-alarm-trigger-relationship.html
    case relType = "RELTYPE" // https://icalendar.org/iCalendar-RFC-5545/3-2-15-relationship-type.html
    case role = "ROLE" // https://icalendar.org/iCalendar-RFC-5545/3-2-16-participation-role.html
    case rsvp = "RSVP" // https://icalendar.org/iCalendar-RFC-5545/3-2-17-rsvp-expectation.html
    case sentBy = "SENT-BY" // https://icalendar.org/iCalendar-RFC-5545/3-2-18-sent-by.html
    case tzid = "TZID" // https://icalendar.org/iCalendar-RFC-5545/3-2-19-time-zone-identifier.html
    case value = "VALUE" // https://icalendar.org/iCalendar-RFC-5545/3-2-20-value-data-types.html
}

