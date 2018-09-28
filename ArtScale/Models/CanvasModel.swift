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

// Local delegate that has full access to the state
protocol CanvasModelLocalDelegate: class {
    func updated()
}

// Delegate that gets serialized updates
protocol CanvasModelSerializedDelegate: class {
    func update(stateUpdate: String)
}

class CanvasModel: CanvasModelSerializedDelegate {
    var localDelegates: [CanvasModelLocalDelegate] = []
    var serializedDelegates: [CanvasModelSerializedDelegate] = []

    private var canvas = Canvas()

    func addStroke(stroke: Stroke) {
        canvas.addStroke(stroke)
        // Send update to local delegates.
        for delegate in localDelegates {
            delegate.updated()
        }

        // Send update to serialized delegates
        let stateUpdate = self.stateUpdate()
        for delegate in serializedDelegates {
            delegate.update(stateUpdate: stateUpdate)
        }
    }

    func stateUpdate() -> String {
        // FIXME: Error handling!
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(canvas)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString ?? "{}"
        } catch {
            return "{}"
        }
    }

    func allStrokes() -> [Stroke] {
        return canvas.allStrokes()
    }

    func update(stateUpdate: String) {
        // FIXME: Error handling!
//        Log.info?.value(stateUpdate)

        let jsonDecoder = JSONDecoder()
        let jsonData = stateUpdate.data(using: .utf8)!
        do {
            canvas = try jsonDecoder.decode(Canvas.self, from: jsonData)
        } catch {
            Log.error?.message("Failed to decode JSON string!")
        }
        for delegate in localDelegates {
            delegate.updated()
        }
    }
}
