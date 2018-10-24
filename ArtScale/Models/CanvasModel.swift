//
//  StrokeModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import CleanroomLogger
import Foundation

class Point: Codable {
    var date: Date
    var x: Double
    var y: Double
    init(x: Double, y: Double) {
        date = Date()
        self.x = x
        self.y = y
    }
}

class Style: Codable {
    private(set) var params: String

    init(params: String) {
        self.params = params
    }
}

class Stroke: Codable {
    var id: UUID
    var date: Date
    private(set) var style: Style
    private(set) var points: [Point]

    init() {
        date = Date()
        id = UUID()
        points = []
        style = Style(params: "randColor")
    }

    func addPoint(x: Double, y: Double) {
        self.addPoint(point: Point(x: x, y: y))
    }

    func addPoint(point: Point) {
        self.points.append(point)
    }
}

class Layer: Codable {
    private(set) var strokes: [Stroke]
    init() {
        strokes = []
    }

    func addStroke(_ stroke: Stroke) {
        strokes.append(stroke)
    }
}

class Canvas: Codable {
    var layers: [Layer]

    init() {
        layers = []
    }

    // Add stroke to latest layer
    func addStroke(_ stroke: Stroke) {
        if layers.count == 0 {
            layers.append(Layer())
        }
        layers[0].addStroke(stroke)
    }

    func allStrokes() -> [Stroke] {
        var allStrokes: [Stroke] = []
        for layer in layers {
            allStrokes.append(contentsOf: layer.strokes)
        }
        return allStrokes
    }
}

protocol CanvasModelLocalObserver: class {
    func canvasModelUpdate(canvasModel: CanvasModel)
}

class CanvasModel: P2PState, P2PStateDelegate {
    private var canvas = Canvas()

    override init() {
        super.init()
        self.delegate = self
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

    func allStrokes() -> [Stroke] {
        return canvas.allStrokes()
    }

    func p2pStateReceiveFullUpdate(p2pState: P2PState, fullUpdate: Data) {
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
