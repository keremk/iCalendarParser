//
//  Parser.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 12/4/16.
//  Copyright © 2016 Kerem Karatal. All rights reserved.
//

import Foundation

enum NodeType {
    case Component
    case Property
    case Parameter
}

protocol Parsable: class {
    var parent: Parsable? { get set }
    var children: [Parsable] { get }
    var nodeType: NodeType { get }
    func appendNewNode(_ node: Parsable)
}

enum NodeValue<T: Comparable> {
    case Component(ComponentType, ComponentIndicator)
    case Property(PropertyName, T)
    case Parameter(ParameterName, T)
}

extension NodeValue {
    static func == (lhs: NodeValue<T>, rhs: NodeValue<T>) -> Bool {
        var isEqual = false
        switch (lhs, rhs) {
        case (.Component(let lhsType, let lhsIndicator), .Component(let rhsType, let rhsIndicator)):
            isEqual = (lhsType == rhsType) && (lhsIndicator == rhsIndicator)
            break
        case (.Property(let lhsName, let lhsValue), .Property(let rhsName, let rhsValue)):
            isEqual = (lhsName == rhsName) && (lhsValue == rhsValue)
            break
        case (.Parameter(let lhsName, let lhsValue), .Parameter(let rhsName, let rhsValue)):
            isEqual = (lhsName == rhsName) && (lhsValue == rhsValue)
            break
        case (.Component(_, _), _), (.Property(_, _), _), (.Parameter(_, _), _):
            isEqual  = false
            break
        }
        return isEqual
    }
}

final class Node<T: Comparable> : Parsable {
    let nodeValue: NodeValue<T>
    
    weak var parent: Parsable?
    var children: [Parsable] = []
    var nodeType: NodeType {
        get {
            switch self.nodeValue {
            case .Component(_, _):
                return NodeType.Component
            case .Parameter(_, _):
                return NodeType.Parameter
            case .Property(_, _):
                return NodeType.Property
            }
        }
    }
    
    init(nodeValue: NodeValue<T>) {
        self.nodeValue = nodeValue
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
        case .Node(let node):
            handleNode(node: node)
            break
        case .None(let error):
            logError(error: error, tokens: tokens)
            break
        }
    }

    private mutating func handleNode(node: Parsable) {
        switch node.nodeType {
        case .Component:
            let componentNode = node as! Node<ComponentValueType>
            handleComponentNode(node: componentNode)
            break
        case .Parameter, .Property:
            handleOtherNode(node: node)
            break
        }
    }
    
    private mutating func handleComponentNode(node: Node<ComponentValueType>) {
        
        switch node.nodeValue {
        case .Component(let componentType, let componentIndicator):
            switch (componentIndicator, componentType) {
            case (.Begin, .Calendar):
                activeParentNode = node
                rootNode = node
                break
            case (.End, .Calendar):
                // Must end here
                break
            case (.Begin, _):
                activeParentNode?.appendNewNode(node)
                activeParentNode = node
                break
            case (.End, _):
                activeParentNode = activeParentNode?.parent
                // Discard End node, it is not represented in the tree
                break
            }
        default:
            break
        }
    }
    
    private mutating func handleOtherNode(node: Parsable) {
        switch node.nodeType {
        case .Property:
            activeParentNode?.appendNewNode(node)
            activePropertyNode = node
            break
        case .Parameter:
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
