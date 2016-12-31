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

protocol TreeNode: class {
    var parent: TreeNode? { get set }
    var children: [TreeNode] { get }
    var type: NodeType { get }
    var name: ElementName { get }
    
    func appendNewNode(_ node: TreeNode)
}

final class Node<T: Equatable> : TreeNode {
    let value: T
    let name: ElementName
    let type: NodeType
    
    weak var parent: TreeNode?
    var children: [TreeNode] = []
    
    init(name: ElementName, value: T, type: NodeType) {
        self.name = name
        self.value = value
        self.type = type
    }
    
    func appendNewNode(_ node: TreeNode) {
        children.append(node)
        node.parent = self
    }
}

struct ParserError {
    let error: RuleError
    let tokens: [Token]
}

struct ASTGenerator {
    var errors: [ParserError] = []
    var rootNode: TreeNode?
    var activeParentNode: TreeNode?
    var activePropertyNode: TreeNode?
    
    internal mutating func generate(tokens: [Token]) -> TreeNode? {
        var tokensPerLine:[Token] = []
        
        for token in tokens {
            if token == Token.contentLine {
                for tokensInGroup in tokensPerLine.groupTokens() {
                    generateNode(tokens: tokensInGroup)
                }
                tokensPerLine = []
            } else {
                tokensPerLine.append(token)
            }            
        }
        return rootNode
    }
    
    private mutating func generateNode(tokens: [Token]) {
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

    private mutating func handleNode(node: TreeNode) {
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
    
    private mutating func handleOtherNode(node: TreeNode) {
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
