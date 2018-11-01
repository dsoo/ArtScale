//
//  CanvasModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import CleanroomLogger
import Foundation

typealias StrokeID = P2PID
typealias LayerID = P2PID
typealias CanvasID = P2PID

class Point: Codable {
    var x: Double
    var y: Double
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

class Stroke: P2PNode {
    private(set) var points: [Point]
    var layerID: LayerID?

    init(layerID: LayerID?) {
        self.layerID = layerID
        points = []
        super.init(type: "Stroke")
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    func addPoint(x: Double, y: Double) {
        self.addPoint(point: Point(x: x, y: y))
    }

    func addPoint(point: Point) {
        self.points.append(point)
    }
}

class Layer: P2PNode {
    var orderedStrokes: [StrokeID] = []
    weak var canvas: Canvas?
    init(canvas: Canvas?) {
        super.init(type: "Layer")
        self.canvas = canvas
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    func addStroke(_ stroke: Stroke) {
        orderedStrokes.append(stroke.id)
    }
}

class Canvas: P2PNode {
//    var layers: [LayerID: Layer] = [:]
//    var orderedLayers: [LayerID] = []
//    var strokes: [StrokeID: Stroke] = [:]

    init() {
        super.init(type: "Canvas")
        self.propNCs["layers"] = [P2PID: P2PNode]:[]
    }

    //
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    //Add stroke to latest layer
    func addStroke(_ stroke: Stroke) {
        if layers.count == 0 {
            _ = addLayer()
            let newLayer = Layer(canvas: self)
            layers[newLayer.id] = newLayer
        }
        layers.first!.value.addStroke(stroke)

        //FIXME: dirty the node
    }

    func addLayer() -> Layer {
        let layer = Layer(canvas: self)
        return addLayer(layer: layer)
    }

    func addLayer(layer: Layer) -> Layer {
        // FIXME: Should we ever allow layers to move between canvases? I don't think so.
        layers[layer.id] = layer
        orderedLayers.append(layer.id)
        return layer
    }

    func allStrokes() -> [Stroke] {
        var allStrokes: [Stroke] = []
        for (layerID) in orderedLayers {
            let layer = layers[layerID]
            for strokeID in layer!.orderedStrokes {
                allStrokes.append(strokes[strokeID]!)
            }
        }
        return allStrokes
    }
}

class CanvasModel: P2PState {
    var localObservers: [P2PStateLocalObserver] = []
    var remoteObservers: [P2PStateRemoteObserver] = []
    private var canvas = Canvas()

    func allStrokes() -> [Stroke] {
        return canvas.allStrokes()
    }

    func addStroke(stroke: Stroke) {
        canvas.addStroke(stroke)
        updateAllObservers()
    }

    func p2pStateMakeFullUpdate(p2pState: P2PState) -> Data {
        // FIXME: Error handling!
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(canvas)
            return jsonData
        } catch {
            return String("{}").data(using: .utf8)!
        }
    }

    func p2pStateApplyFullUpdate(p2pState: P2PState, fullUpdate: Data) {
        // Received a state update from a remote canvas, update our state
        // FIXME: Error handling!
        let jsonDecoder = JSONDecoder()
        do {
            canvas = try jsonDecoder.decode(Canvas.self, from: fullUpdate)
        } catch {
            Log.error?.message("Failed to decode JSON data!")
        }
    }
}
