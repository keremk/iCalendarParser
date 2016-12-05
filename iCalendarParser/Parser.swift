//
//  Parser.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation


enum NodeType {
    case BeginCalendar
    case EndCalendar
    case BeginComponent
    case EndComponent
    case Property
    case PropertyParameter
}

protocol Parsable {
    var parent: Parsable? { get set }
    var nodeType: NodeType { get }
    mutating func appendNewNode(_ node: Parsable)
}

struct Node<T: Comparable> : Parsable {
    let name: String
    let value: T
    let nodeType: NodeType
    
    var parent: Parsable?
    var children: [Parsable] = []
    
    init(name: String, value: T, nodeType: NodeType) {
        self.name = name
        self.value = value
        self.nodeType = nodeType
    }
    
    mutating func appendNewNode(_ node: Parsable) {
        children.append(node)
    }
}

struct Parser {
    var activeNode: Parsable?
    var activePropertyNode: Parsable?
    
    public mutating func parse(tokens: [Token]) throws -> Parsable? {
        var tokensPerLine:[Token] = []
        
        for token in tokens {
            if token == Token.contentLine {
                parseNode(tokens: tokensPerLine)
                tokensPerLine = []
            } else {
                tokensPerLine.append(token)
            }
            
        }
        return activeNode
    }

    private mutating func parseNode(tokens: [Token]) {
        let rules = Rules()

        if let node = rules.invokeRule(tokens: tokens) {
            switch node.nodeType {
            case .BeginCalendar:
                activeNode = node
                activeNode?.parent = Optional.none
                break
            case .EndCalendar:
                // Must end here
                break
            case .BeginComponent:
                if var copyActiveNode = activeNode {
                    copyActiveNode.appendNewNode(node)
                    activeNode = node
                    activeNode?.parent = copyActiveNode
                }
                break
            case .EndComponent:
                if var copyActiveNode = activeNode {
                    activeNode = copyActiveNode.parent
                }
                // Discard node
                break
            case .Property:
                activeNode?.appendNewNode(node)
                activePropertyNode = node
                break
            case .PropertyParameter:
                activePropertyNode?.appendNewNode(node)
                break
            }
        }
    }
}
