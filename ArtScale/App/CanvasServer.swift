//
//  CanvasServer.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/18/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import Network
import CleanroomLogger

// The CanvasServer is a peer-to-peer service that synchronizes client state
// with other peers.

class CanvasServer {
    var name: String
    var listener: NWListener
    var serverQueue: DispatchQueue
    var canvasPeerConnections: [CanvasPeerConnection] = []
    var canvasModel: CanvasModel

    // FIXME: Need to track connection state per connection, not globally
    var connected: Bool = false

    init(name: String, canvasModel: CanvasModel) {
        Log.info?.message("CanvasServer:\(name) init")
        self.name = name
        self.canvasModel = canvasModel
        serverQueue = DispatchQueue(label: "Canvas Server Queue")

        // First, initialize the server
        listener = try! NWListener(using: NWParameters.tcp)
        listener.service = NWListener.Service(name: name, type: "_canvas._tcp")
        listener.serviceRegistrationUpdateHandler = { (serviceChange) in
            switch (serviceChange) {
            case .add(let endpoint):
                switch endpoint {
                case let .service(name, _, _, _):
                    Log.info?.message("Listening as \(name)")
                default:
                    break
                }
            default:
                break
            }
        }

        listener.newConnectionHandler = { [weak self] (newConnection) in
            Log.info?.message("Got new connection!")
            if let strongSelf = self {
                let newPeerConnection = CanvasPeerConnection(name: strongSelf.name, peerName: "incoming", connection: newConnection, canvasModel: strongSelf.canvasModel, isClient: false)
                strongSelf.canvasPeerConnections.append(newPeerConnection)
            }
        }

        listener.stateUpdateHandler = { [weak self] (newState) in
            switch(newState) {
            case.ready:
                Log.info?.message("Listening on port \(String(describing: self?.listener.port))")
            case .failed(let error):
                Log.info?.message("Listener failed with error \(error)")
            default:
                break
            }
        }
        listener.start(queue: serverQueue)

        // Now that we've advertised ourself, find all of the existing
        // _canvas._tcp services out there and connect ourselves to them.
    }

    func connectToPeer(peerName: String) {
        Log.info?.message("CanvasServer:\(self.name) connecting to: \(peerName)")
        // Create connection, then hand off everything else to CanvasPeerConnection
        let connection = NWConnection(to: NWEndpoint.service(name: name, type: "_canvas._tcp", domain: "local", interface: nil), using: NWParameters.tcp)
        let newPeerConnection = CanvasPeerConnection(name: self.name, peerName: peerName, connection: connection, canvasModel: self.canvasModel, isClient: true)
        self.canvasPeerConnections.append(newPeerConnection)
    }
}
