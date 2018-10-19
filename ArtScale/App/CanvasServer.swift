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

class CanvasServer: CanvasModelRemoteObserver {
    var listener: NWListener
    var queue: DispatchQueue
    var connected: Bool = false

    init?() {
        queue = DispatchQueue(label: "Canvas Server Queue")

        listener = try! NWListener(using: NWParameters.tcp)
        listener.service = NWListener.Service(type: "_canvas._tcp")
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
            if let strongSelf = self {
                Log.info?.message("Got new connection!")
                newConnection.start(queue: strongSelf.queue)
                Log.info?.trace()
                strongSelf.receive(on: newConnection)
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
        listener.start(queue: queue)
    }

    func receive(on connection: NWConnection) {
        Log.info?.trace()
        connection.receive(minimumIncompleteLength: 5, maximumLength: 5, completion: {(content, _, _, _) in
            Log.info?.trace()
            if let data = content {
                if !self.connected {
                    // Do initial connection
                    connection.send(content: data, completion: .idempotent)
                    self.connected = true
                }
                Log.info?.value(data)
            }
        })
    }

    func canvasModelStateUpdate(canvasModel: CanvasModel, stateUpdate: String) {
        // Send update to connected cleints
    }
}
