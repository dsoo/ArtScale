//
//  StrokeModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import CleanroomLogger
import Foundation

struct Point {
    var x: Double
    var y: Double
}

struct Stroke {
    var points: [Point]
}

struct Layer {
    var strokes: [Stroke]
}

struct Canvas {
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
    func update(stateUpdate: CanvasModelStateUpdate)
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
    
    func stateUpdate() -> CanvasModelStateUpdate {
        return CanvasModelStateUpdate(canvasState:strokes)
    }
    
    func update(stateUpdate: CanvasModelStateUpdate) {
        Log.info?.value(stateUpdate)
        strokes = stateUpdate.canvasState
        for delegate in localDelegates {
            delegate.updated()
        }
    }
}
