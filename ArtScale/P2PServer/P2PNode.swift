//
//  P2PNode.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/29/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation

typealias P2PNodeType = String
typealias P2PPropName = String
typealias P2PID = UUID
typealias P2PNodeCollection = [P2PID: P2PNode]
typealias P2PValueCollection = [P2PID: P2PValue]
typealias P2PValue = Codable

class P2PVersionHash: Codable {
    // Implement as a CRC32
}

extension Array {
    // Add methods for P2P updates
}

extension Dictionary {
    // Add methods for P2P updates
}

class P2PNode: Codable {
    let type: P2PNodeType
    let id: P2PID = P2PID()
    let updateTime: Date
    var version: P2PVersionHash
    var propVals: [P2PPropName: P2PValue] = [:]
    var propVCs: [P2PPropName: P2PValueCollection] = [:]
    var propNCs: [P2PPropName: P2PNodeCollection] = [:]

    init(type: P2PNodeType) {
        // Calculate initial version hash
        self.type = type
        self.updateTime = Date()
        self.version = P2PVersionHash()
    }

    func dirtyProp(_ name: P2PPropName) {}
    func dirtyPropVC(_ name: P2PPropName) {}
    func dirtyPropNC(_ name: P2PPropName) {}
}
