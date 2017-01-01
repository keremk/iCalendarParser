//
//  FileReader.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 1/1/17.
//  Copyright © 2017 Kerem Karatal. All rights reserved.
//

import Foundation

func readFile(filename: String) -> Data? {
    return Bundle(for: FileReader.self).path(forResource: filename, ofType: "ics")
        .flatMap { URL(fileURLWithPath: $0) }
        .flatMap { try? Data(contentsOf: $0) }
}


final private class FileReader { }
