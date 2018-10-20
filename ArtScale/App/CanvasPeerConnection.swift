//
//  CanvasPeerConnection.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/20/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import Network
import CleanroomLogger

// Maintains all state necessary to synchronize the state of a canvas with a peer

class CanvasPeerConnection: CanvasModelRemoteObserver {
    var connection: NWConnection
    var queue: DispatchQueue
    var isClient: Bool = false
    var connected: Bool = false
    var canvasModel: CanvasModel?

    init(connection: NWConnection, canvasModel: CanvasModel, isClient: Bool) {
        Log.info?.trace()
        self.connection = connection
        self.isClient = isClient

        queue = DispatchQueue(label: "Canvas Peer Queue")

        // If we are the client, we are responsible for initiating the handshake by
        // telling the server our basic information

        canvasModel.remoteObservers.append(self)

        connection.stateUpdateHandler = { [weak self] (newState) in
            switch(newState) {
            case .ready:
                Log.info?.message("Ready to send")
                if (self?.isClient)! {
                    self?.sendHandshake()
                } else {
                    self?.receiveHandshake()
                }
            case .preparing:
                Log.info?.message("Preparing")
            case .setup:
                Log.info?.message("Setup")
            case .cancelled:
                Log.info?.message("Cancelled")
            case .failed(let error):
                Log.info?.message("Client failed with error: \(error)")
            case .waiting(let error):
                Log.info?.message("Client waiting with error: \(error)")
            }
        }

        connection.start(queue: queue)
    }

    // If we are the "server", handle receiving the handshake from the client
    func receiveHandshake() {
        Log.info?.trace()
        connection.receive(minimumIncompleteLength: 5, maximumLength: 5, completion: {[weak self] (content, _, _, _) in
            Log.info?.trace()
            if let strongSelf = self {
                if let data = content {
                    if !strongSelf.connected {
                        // Do initial connection
                        strongSelf.connection.send(content: data, completion: .idempotent)
                        strongSelf.connected = true
                    }
                    Log.info?.value(data)
                }
            }
        })
    }

    func sendHandshake() {
        let helloMessage = "hello".data(using: .utf8)
        connection.send(content: helloMessage, completion: .contentProcessed({ (error) in
            if let error = error {
                Log.info?.message("Send error: \(error)")
            }
        }))
        connection.receive(minimumIncompleteLength: 5, maximumLength: 5, completion: {(content, _, _, _) in
            if content != nil {
                Log.info?.message("Got connected - \(content!)!")
            }
        })
    }

    func canvasModelStateUpdate(canvasModel: CanvasModel, stateUpdate: String) {
        // Send this update over the network to peers.
    }
}
