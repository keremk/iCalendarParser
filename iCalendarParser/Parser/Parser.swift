//
//  Parser.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

enum NodeType {
    case container
    case property
    case parameter
}

protocol Parsable: class {
    var parent: Parsable? { get set }
    var children: [Parsable] { get }
    var type: NodeType { get }
    var name: ElementName { get }
    
    func appendNewNode(_ node: Parsable)
}

final class Node<T: Equatable> : Parsable {
    let value: T
    let name: ElementName
    let type: NodeType
    
    weak var parent: Parsable?
    var children: [Parsable] = []
    
    init(name: ElementName, value: T, type: NodeType) {
        self.name = name
        self.value = value
        self.type = type
    }
    
    func appendNewNode(_ node: Parsable) {
        children.append(node)
        node.parent = self
    }
}

struct ParserError {
    let error: RuleError
    let tokens: [Token]
}

struct Parser {
    var errors: [ParserError] = []
    var rootNode: Parsable?
    var activeParentNode: Parsable?
    var activePropertyNode: Parsable?
    
    public mutating func parse(tokens: [Token]) -> Parsable? {
        var tokensPerLine:[Token] = []
        
        for token in tokens {
            if token == Token.contentLine {
                for tokensInGroup in tokensPerLine.groupTokens() {
                    parseNode(tokens: tokensInGroup)
                }
                tokensPerLine = []
            } else {
                tokensPerLine.append(token)
            }            
        }
        return rootNode
    }
    
    private mutating func parseNode(tokens: [Token]) {
        let ruleOutput =  Rules().invokeRule(tokens: tokens)
        switch ruleOutput {
        case .success(let node):
            handleNode(node: node)
            break
        case .failure(let error):
            logError(error: error as! RuleError, tokens: tokens)
            break
        }
    }

    private mutating func handleNode(node: Parsable) {
        switch node.type {
        case .container:
            handleContainerNode(node: node as! Node<Component>)
            break
        case .parameter, .property:
            handleOtherNode(node: node)
            break
        }
    }
    
    private mutating func handleContainerNode(node: Node<Component>) {
        switch (node.name, node.value) {
        case (.begin, .calendar):
            activeParentNode = node
            rootNode = node
            break
        case (.end, .calendar):
            // Must end here
            break
        case (.begin, _):
            activeParentNode?.appendNewNode(node)
            activeParentNode = node
            break
        case (.end, _):
            activeParentNode = activeParentNode?.parent
            // Discard End node, it is not represented in the tree
            break
        default:
            break
        }
    }
    
    private mutating func handleOtherNode(node: Parsable) {
        switch node.type {
        case .property:
            activeParentNode?.appendNewNode(node)
            activePropertyNode = node
            break
        case .parameter:
            activePropertyNode?.appendNewNode(node)
            break
        default:
            // should never get here
            assert(false)
            break
        }
    }
    
    private mutating func logError(error: RuleError, tokens: [Token]) {
        // TODO: Logging errors
        errors.append(ParserError(error: error, tokens: tokens))
    }
}
