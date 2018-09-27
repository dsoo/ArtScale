//
//  StrokeModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import CleanroomLogger
import Foundation

struct Point: Codable {
    var x: Double
    var y: Double
}

struct Stroke: Codable {
    var points: [Point]
}

class Layer: Codable {
    var strokes: [Stroke]
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
//            Log.info?.value(jsonString)
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
