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

struct Layer: Codable {
    var strokes: [Stroke]
}

struct Canvas: Codable {
    var layers: [Layer]
}

struct CanvasModelStateUpdate {
    var canvasState: [Stroke]
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
    static let shared = CanvasModel()

    var localDelegates: [CanvasModelLocalDelegate] = []
    var serializedDelegates: [CanvasModelSerializedDelegate] = []

    private var strokes: [Stroke] = []

    func allStrokes() -> [Stroke] {
        return strokes
    }

    func addStroke(stroke: Stroke) {
        strokes.append(stroke)
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
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(strokes)
            let jsonString = String(data: jsonData, encoding: .utf8)
            Log.info?.value(jsonString)
            return jsonString ?? "{}"
        }
        catch {
            return "{}"
        }
    }

    func update(stateUpdate: String) {
        Log.info?.value(stateUpdate)

        let jsonDecoder = JSONDecoder()
        let jsonData = stateUpdate.data(using:.utf8)!
        do {
            strokes = try jsonDecoder.decode([Stroke].self, from: jsonData)
        } catch {
            Log.error?.message("Failed to decode JSON string!")
        }
        for delegate in localDelegates {
            delegate.updated()
        }
    }
}
