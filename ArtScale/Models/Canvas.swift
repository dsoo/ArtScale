//
//  Canvas.swift
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
    private(set) var points: [Point] {
        didSet { dirty() }
    }
    var layerID: LayerID? {
        didSet { dirty() }
    }

    init(layerID: LayerID?, canvas: Canvas) {
        self.layerID = layerID
        points = []
        //        if let c = canvas?
        super.init(type: "Stroke", state: canvas.state!)
    }

    private enum CodingKeys: String, CodingKey {
        case points
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = try container.decode([Point].self, forKey: .points)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
    }

    func addPoint(x: Double, y: Double) {
        self.addPoint(point: Point(x: x, y: y))
    }

    func addPoint(point: Point) {
        self.points.append(point)
    }
}

class Layer: P2PNode {
    var orderedStrokes: [StrokeID] = [] {
        didSet { dirty() }
    }
    private(set)weak var canvas: Canvas?
    init(canvas: Canvas) {
        super.init(type: "Layer", state: canvas.state!)
        self.canvas = canvas
    }

    private enum CodingKeys: String, CodingKey {
        case orderedStrokes
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderedStrokes = try container.decode([StrokeID].self, forKey: .orderedStrokes)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderedStrokes, forKey: .orderedStrokes)
    }

    func addStroke(_ stroke: Stroke) {
        orderedStrokes.append(stroke.id)
        self.dirty()
    }
}

class Canvas: P2PNode {
    var layers: [LayerID: Layer] = [:]
    var orderedLayers: [LayerID] = []
    var strokes: [StrokeID: Stroke] = [:]

    init(canvasManager: CanvasManager) {
        super.init(type: "Canvas", state: canvasManager)
    }

    private enum CodingKeys: String, CodingKey {
        case layers
        case orderedLayers
        case strokes
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.layers = try container.decode([LayerID: Layer].self, forKey: .layers)
        self.orderedLayers = try container.decode([LayerID].self, forKey: .orderedLayers)
        self.strokes = try container.decode([StrokeID: Stroke].self, forKey: .strokes)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(layers, forKey: .layers)
        try container.encode(orderedLayers, forKey: .orderedLayers)
        try container.encode(strokes, forKey: .strokes)
    }

    //Add stroke to latest layer
    func addStroke(_ stroke: Stroke) {
        if layers.count == 0 {
            _ = addLayer()
            let newLayer = Layer(canvas: self)
            layers[newLayer.id] = newLayer
        }
        layers.first!.value.addStroke(stroke)
        strokes[stroke.id] = stroke

        //FIXME: dirty the node
        self.dirty()
    }

    func addLayer() -> Layer {
        let layer = Layer(canvas: self)
        return addLayer(layer: layer)
    }

    func addLayer(layer: Layer) -> Layer {
        // FIXME: Should we ever allow layers to move between canvases? I don't think so.
        layers[layer.id] = layer
        orderedLayers.append(layer.id)
        self.dirty()
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
