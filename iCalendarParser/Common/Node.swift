//
//  Node.swift
//  iCalendarParser
//
//  Created by Kerem Karatal on 1/1/17.
//  Copyright © 2017 Kerem Karatal. All rights reserved.
//

import Foundation

public enum NodeType {
    case container
    case property
    case parameter
}

public protocol TreeNode: class {
    var parent: TreeNode? { get set }
    var type: NodeType { get }
    var name: ElementName { get }
    
    func appendNewNode(_ node: TreeNode)
}

public final class Node<T: Equatable> : TreeNode {
    let value: T
    public let name: ElementName
    public let type: NodeType
    
    public weak var parent: TreeNode?
    private var children: [TreeNode] = []
    
    init(name: ElementName, value: T, type: NodeType) {
        self.name = name
        self.value = value
        self.type = type
    }
    
    public func appendNewNode(_ node: TreeNode) {
        children.append(node)
        node.parent = self
    }
    
    public func childNode(name: ElementName) -> TreeNode? {
        return children.filter({ $0.name == name }).first
    }
    
    public func childNodes(type: NodeType) -> [TreeNode] {
        return children.filter({ $0.type == type })
    }
    
    public func childNodes() -> [TreeNode] {
        return children
    }
}
