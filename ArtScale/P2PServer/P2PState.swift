//
//  P2PState.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/23/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation

protocol P2PStateLocalObserver: class {
    func p2pStateUpdate(p2pState: P2PState)
}
protocol P2PStateRemoteObserver {
    func p2pStateUpdate(p2pState: P2PState, stateUpdate: Data)
}

protocol P2PStateDelegate {
    func p2pStateMakeFullUpdate(p2pState: P2PState) -> Data
    func p2pStateReceiveFullUpdate(p2pState: P2PState, fullUpdate: Data)
}

class P2PState: P2PStateRemoteObserver {
    var localObservers: [P2PStateLocalObserver] = []
    var remoteObservers: [P2PStateRemoteObserver] = []
    var delegate: P2PStateDelegate?

    func makeFullUpdate() -> Data {
        return delegate!.p2pStateMakeFullUpdate(p2pState: self)
    }

    func updateAllObservers() {
        let stateUpdate = delegate!.p2pStateMakeFullUpdate(p2pState: self)

        for observer in localObservers {
            observer.p2pStateUpdate(p2pState: self)
        }

        // Notify remote observers that canvas has changed with a serialized update
        for observer in remoteObservers {
            observer.p2pStateUpdate(p2pState: self, stateUpdate: stateUpdate)
        }
    }

    func updateLocalObservers() {
        for observer in localObservers {
            observer.p2pStateUpdate(p2pState: self)
        }
    }

    func p2pStateUpdate(p2pState: P2PState, stateUpdate: Data) {
        // Received a state update from a remote peer, update our state
        delegate!.p2pStateReceiveFullUpdate(p2pState: self, fullUpdate: stateUpdate)
        updateLocalObservers()
    }

}
