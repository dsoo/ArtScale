//
//  P2PStateManager.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/23/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import CleanroomLogger

typealias P2PStateUpdate = Data

protocol P2PStateLocalObserver: class {
    func p2pStateUpdate(p2pState: P2PStateManager)
}
protocol P2PStateRemoteObserver: class {
    func p2pStateUpdate(p2pState: P2PStateManager, stateUpdate: Data)
}

protocol P2PStateManager: class {
    var localObservers: [P2PStateLocalObserver] {get set}
    var remoteObservers: [P2PStateRemoteObserver] {get set}

    func p2pStateMakeFullUpdate(p2pState: P2PStateManager) -> Data
    func p2pStateApplyFullUpdate(p2pState: P2PStateManager, fullUpdate: Data)
}

extension P2PStateManager {
    func makeFullUpdate() -> P2PStateUpdate {
        return p2pStateMakeFullUpdate(p2pState: self)
    }

    func updateAllObservers() {
        let stateUpdate = p2pStateMakeFullUpdate(p2pState: self)

        for observer in localObservers {
            observer.p2pStateUpdate(p2pState: self)
        }

        // Notify remote observers that state has changed with a serialized update
        for observer in remoteObservers {
            observer.p2pStateUpdate(p2pState: self, stateUpdate: stateUpdate)
        }
    }

    func updateLocalObservers() {
        for observer in localObservers {
            observer.p2pStateUpdate(p2pState: self)
        }
    }

    func queueUpdate() {
    }

    func decodeNode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        // Received a state update from a remote canvas, update our state
        // FIXME: Error handling!
        var node: T?
        let jsonDecoder = JSONDecoder()
        do {
            node = try jsonDecoder.decode(type, from: data)
        } catch {
            // canvas = Canvas(canvasManager: self)
            Log.error?.message("Failed to decode JSON data! \(error)")
        }
        return node!
    }

    func update(p2pState: P2PStateManager, stateUpdate: P2PStateUpdate) {
        // Received a state update from a remote peer, update our state
        p2pStateApplyFullUpdate(p2pState: self, fullUpdate: stateUpdate)
        updateLocalObservers()
    }
}
