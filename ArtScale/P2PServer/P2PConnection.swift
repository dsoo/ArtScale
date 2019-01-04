//
//  P2PConnection.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/20/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import Network
import CleanroomLogger

class P2PConnection: P2PStateRemoteObserver {
    var name: String
    var peerName: String
    var connection: NWConnection
    var queue: DispatchQueue
    var isClient: Bool = false
    var connected: Bool = false
    var p2pState: P2PStateManager?

    func info(_ message: String) {
        Log.info?.message("CPC:\(self.name)->\(self.peerName): \(message)")
    }

    init(name: String, peerName: String, connection: NWConnection, p2pState: P2PStateManager, isClient: Bool) {
        Log.info?.message("CPC:\(name)->\(peerName): init")
        self.name = name
        self.peerName = peerName
        self.connection = connection
        self.p2pState = p2pState
        self.isClient = isClient

        queue = DispatchQueue(label: "P2PConnection Peer Queue")

        // If we are the client, we are responsible for initiating the handshake by
        // telling the server our basic information

        self.p2pState!.remoteObservers.append(self)

        connection.stateUpdateHandler = { [weak self] (newState) in
            switch(newState) {
            case .ready:
                self?.info("Ready")
                if (self?.isClient)! {
                    self?.sendHandshake()
                } else {
                    self?.receiveMessage()
                }
            case .preparing:
                self?.info("Preparing")
            case .setup:
                self?.info("Setup")
            case .cancelled:
                self?.info("Cancelled")
            case .failed(let error):
                self?.info("Failed with error: \(error)")
            case .waiting(let error):
                self?.info("Waiting with error: \(error)")
            }
        }

        connection.start(queue: queue)
    }

    // If we are the "server", handle receiving the handshake from the client
    func receiveHandshake() {
        info("receiveHandshake")
        receiveMessage()
    }

    func sendHandshake() {
        // Just send the state of the current canvas to the server
        sendMessage(body: p2pState!.makeFullUpdate())
        receiveMessage()
    }

    func receiveMessage() {
        info("receiveMessage")
        connection.receive(minimumIncompleteLength: 8, maximumLength: 8, completion: {[weak self] (content, contentContext, isComplete, error) in
            self!.info("\(String(describing: contentContext)),\(isComplete),\(String(describing: error))")
            if (content != nil) && (content!.count > 0) {
                self!.info("receiveMessage:\(content!.count)")
                let len = Int(String(bytes: content!, encoding: .utf8)!)!
                self!.receiveBody(len: len)
            } else if !isComplete {
                self!.receiveMessage()
            } else {
                self!.info("Closing connection: \(self!.connection)")
            }
        })
    }

    func receiveBody(len: Int) {
        connection.receive(minimumIncompleteLength: len, maximumLength: len, completion: {[weak self] (content, _, _, _) in
            if content != nil {
                self!.handleMessage(body: content!)
                self!.receiveMessage()
            }
        })
    }

    func handleMessage(body: Data) {
        info("handleMessage: \(body.count) bytes")
        p2pState!.update(p2pState: p2pState!, stateUpdate: body)
    }

    func packMessage(body: Data) -> Data? {
        // Pack a message with standardized header
        let len = body.count
        let messageStr = String(format: "%08d", len)
        var message = messageStr.data(using: .utf8)
        message!.append(body)
        return message
    }

    func sendMessage(body: Data) {
        let packedData = packMessage(body: body)
        info("Sending \(body.count) bytes")
        connection.send(content: packedData, completion: .contentProcessed({[weak self] (error) in
            if let error = error {
                self!.info("Send error: \(error)")
            }
        }))
    }

    //
    // Implement P2PStateRemoteObserver
    //
    func p2pStateUpdate(p2pState: P2PStateManager, stateUpdate: Data) {
        info("p2pSU")
        // Send this update over the network to peers.
        sendMessage(body: p2pState.makeFullUpdate())
    }
}
