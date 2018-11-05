//
//  P2PNode.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/29/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import CleanroomLogger
//import CryptoSwift

typealias P2PNodeType = String
typealias P2PPropName = String
typealias P2PID = UUID
typealias P2PNodeCollection = [P2PID: P2PNode]
typealias P2PValueCollection = [P2PID: P2PValue]
typealias P2PValue = Codable

typealias P2PVersionHash = Data // CRC32

class P2PNode: Codable {
    let type: P2PNodeType
    let id: P2PID = P2PID()
    let updateTime: Date
    var version: P2PVersionHash

    private(set) var state: P2PStateManager?

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case updateTime
        case version
    }

    init(type: P2PNodeType, state: P2PStateManager) {
        // Calculate initial version hash
        self.type = type
        self.state = state
        self.updateTime = Date()
        self.version = P2PVersionHash()
    }

    func calculateVersion() {
//        do {
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(self)
//            version = jsonData.crc32()
//        } catch {
//            Log.error?.message("Error calculating version! \(error)")
//        }
    }

    func dirty() {
        // Tell the manager that this node is dirty
        state!.dirty(type: type, id: id)
    }
}
