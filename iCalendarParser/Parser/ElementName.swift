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
    case altRep = "ALTREP"
    case rsvp = "RSVP"
    case cutype = "CUTYPE"
    case cn = "CN"
}

