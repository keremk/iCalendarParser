//
//  ElementName.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/28/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

public enum ElementName: String, RawRepresentable {
    // MARK: Components
    case begin = "BEGIN"
    case end = "END"
    // MARK: Calendar Properties
    case calScale = "CALSCALE" // https://icalendar.org/iCalendar-RFC-5545/3-7-1-calendar-scale.html
    case method = "METHOD" // https://icalendar.org/iCalendar-RFC-5545/3-7-2-method.html
    case prodId = "PRODID" // https://icalendar.org/iCalendar-RFC-5545/3-7-3-product-identifier.html
    case version = "VERSION" // https://icalendar.org/iCalendar-RFC-5545/3-7-4-version.html
    // MARK: Descriptive Component Properties
    case attach = "ATTACH" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-1-attachment.html
    case categories = "CATEGORIES" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-2-categories.html
    case classification = "CLASS" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-3-classification.html
    case comment = "COMMENT" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-4-comment.html
    case description = "DESCRIPTION" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-5-description.html
    case geo = "GEO" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-6-geographic-position.html
    case location = "LOCATION" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-7-location.html
    case percentComplete = "PERCENT-COMPLETE" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-8-percent-complete.html
    case priority = "PRIORITY" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-9-priority.html
    case resources = "RESOURCES" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-10-resources.html
    case status = "STATUS" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-11-status.html
    case summary = "SUMMARY" // https://icalendar.org/iCalendar-RFC-5545/3-8-1-12-summary.html
    // MARK: Date and Time Component Properties
    case completed = "COMPLETED" // https://icalendar.org/iCalendar-RFC-5545/3-8-2-1-date-time-completed.html
    case dtend = "DTEND" // https://icalendar.org/iCalendar-RFC-5545/3-8-2-2-date-time-end.html
    case due = "DUE" // https://icalendar.org/iCalendar-RFC-5545/3-8-2-3-date-time-due.html
    case dtstart = "DTSTART" // https://icalendar.org/iCalendar-RFC-5545/3-8-2-4-date-time-start.html
    case duration = "DURATION" // https://icalendar.org/iCalendar-RFC-5545/3-8-2-5-duration.html
    case freeBusy = "FREEBUSY" // https://icalendar.org/iCalendar-RFC-5545/3-8-2-6-free-busy-time.html
    case transparency = "TRANSP" // https://icalendar.org/iCalendar-RFC-5545/3-8-2-7-time-transparency.html
    // MARK: Timezone Component Properties
    // TODO: What to do with tzid which is both a parameter and property
    case tzName = "TZNAME" // https://icalendar.org/iCalendar-RFC-5545/3-8-3-2-time-zone-name.html
    case tzOffsetFrom = "TZOFFSETFROM" // https://icalendar.org/iCalendar-RFC-5545/3-8-3-3-time-zone-offset-from.html
    case tzOffsetTo = "TZOFFSETTO" // https://icalendar.org/iCalendar-RFC-5545/3-8-3-4-time-zone-offset-to.html
    case tzUrl = "TZURL" // https://icalendar.org/iCalendar-RFC-5545/3-8-3-5-time-zone-url.html
    // MARK: Relationship Component Properties
    case attendee = "ATTENDEE" // https://icalendar.org/iCalendar-RFC-5545/3-8-4-1-attendee.html
    case contact = "CONTACT" // https://icalendar.org/iCalendar-RFC-5545/3-8-4-2-contact.html
    case organizer = "ORGANIZER" // https://icalendar.org/iCalendar-RFC-5545/3-8-4-3-organizer.html
    case recurrenceId = "RECURRENCE-ID" // https://icalendar.org/iCalendar-RFC-5545/3-8-4-4-recurrence-id.html
    case relatedTo = "RELATED-TO" // https://icalendar.org/iCalendar-RFC-5545/3-8-4-5-related-to.html
    case url = "URL" // https://icalendar.org/iCalendar-RFC-5545/3-8-4-6-uniform-resource-locator.html
    case uid = "UID" // https://icalendar.org/iCalendar-RFC-5545/3-8-4-7-unique-identifier.html
    // MARK: Recurrence Component Properties
    case exDate = "EXDATE" // https://icalendar.org/iCalendar-RFC-5545/3-8-5-1-exception-date-times.html
    // TODO: RECUR, RDATE, RRULE
    // MARK: Alarm Component Properties
    case action = "ACTION" // https://icalendar.org/iCalendar-RFC-5545/3-8-6-1-action.html
    case repeatCount = "REPEAT" // https://icalendar.org/iCalendar-RFC-5545/3-8-6-2-repeat-count.html
    // TODO: TRIGGER
    // MARK: Change Management Component Properties
    case created = "CREATED" // https://icalendar.org/iCalendar-RFC-5545/3-8-7-1-date-time-created.html
    case dtStamp = "DTSTAMP" // https://icalendar.org/iCalendar-RFC-5545/3-8-7-2-date-time-stamp.html
    case lastModified = "LAST-MODIFIED" // https://icalendar.org/iCalendar-RFC-5545/3-8-7-3-last-modified.html
    case sequence = "SEQUENCE" // https://icalendar.org/iCalendar-RFC-5545/3-8-7-4-sequence-number.html
    // MARK: Misc Component Properties
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
