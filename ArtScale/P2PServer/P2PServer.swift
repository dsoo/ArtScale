//
//  P2PServer.swift
//  ArtScale
//
//  Created by Douglas Soo on 10/18/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import Network
import CleanroomLogger

// The P2PServer is a peer-to-peer service that synchronizes state
// with other peers.

class P2PServer: NSObject, NetServiceBrowserDelegate {
    let p2pType = "_canvas._tcp"
    var name: String
    var listener: NWListener
    var serverQueue: DispatchQueue
    var p2pConnections: [P2PConnection] = []
    var p2pState: P2PState
    var peerServices: [NetService] = []

    // FIXME: Need to track connection state per connection, not globally
    var connected: Bool = false

    func info(_ message: String) {
        Log.info?.message("P2PS:\(self.name): \(message)")
    }

    init(name: String, p2pState: P2PState) {
        Log.info?.message("P2PS:\(name) init")
        self.name = name
        self.p2pState = p2pState

        // First, initialize the server
        listener = try! NWListener(using: NWParameters.tcp)
        listener.service = NWListener.Service(name: name, type: p2pType)
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

        serverQueue = DispatchQueue(label: "P2PServer Queue")
        super.init()

        listener.newConnectionHandler = { [weak self] (newConnection) in
            self!.info("newConnection \(newConnection)")
            if let strongSelf = self {
                let newPeerConnection = P2PConnection(name: strongSelf.name, peerName: "incoming", connection: newConnection, p2pState: strongSelf.p2pState, isClient: false)
                strongSelf.p2pConnections.append(newPeerConnection)
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
    }

    func findPeers() {
        info("Finding peers")
        // Use NetServiceBrowser to find peer networks
        let nsb = NetServiceBrowser()
        nsb.delegate = self
        nsb.searchForServices(ofType: p2pType, inDomain: "local")
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
    }

    //
    // NetServiceBrowser methods
    //
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        info("found peer \(service.name)")
        // FIXME: Find a better way to identify yourself.
        if (service.name != self.name) {
            peerServices.append(service)
            connectToPeer(peerName: service.name)
        }
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String: NSNumber]) {
        // Did not successfully find any services
        Log.info?.trace()
    }

    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        Log.info?.trace()
    }

    func connectToPeer(peerName: String) {
        info("connecting to: \(peerName)")
        // Create connection, then hand off everything else P2PPeerConnection
        let connection = NWConnection(to: NWEndpoint.service(name: peerName, type: p2pType, domain: "local", interface: nil), using: NWParameters.tcp)
        let newPeerConnection = P2PConnection(name: self.name, peerName: peerName, connection: connection, p2pState: self.p2pState, isClient: true)
        self.p2pConnections.append(newPeerConnection)
    }

}
