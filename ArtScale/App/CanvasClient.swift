//
//  CanvasClient.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/18/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import Network
import CleanroomLogger

class CanvasClient: CanvasModelRemoteObserver {
    var connection: NWConnection
    var queue: DispatchQueue
    var connected: Bool = false
    var canvasModel: CanvasModel?

    init(name: String, canvasModel: CanvasModel) {
        Log.info?.trace()

        queue = DispatchQueue(label: "Canvas Client Queue")
        connection = NWConnection(to: NWEndpoint.service(name: name, type: "_canvas._tcp", domain: "local", interface: nil), using: NWParameters.tcp)

        connection.stateUpdateHandler = { [weak self] (newState) in
            switch(newState) {
            case .ready:
                Log.info?.message("Ready to send")
                self?.sendHandshake()
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

        canvasModel.remoteObservers.append(self)

        connection.start(queue: queue)
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
