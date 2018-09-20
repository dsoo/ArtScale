//
//  StrokeModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

// Only importing for CGPoint
import UIKit

struct Stroke {
    var points: [CGPoint]
}

struct Layer {
    var strokes: [Stroke]
}

struct Canvas {
    var layers: [Layer]
}

protocol CanvasModelDelegate: class {
    func canvasUpdated()
}

class CanvasModel {
    static let shared = CanvasModel()
    
    var delegates: [CanvasModelDelegate] = []

    private var strokes: [Stroke] = []

    func allStrokes() -> [Stroke] {
        return strokes
    }

    func addStroke(stroke: Stroke) {
        strokes.append(stroke)
        // Send update to anything listening.
        for delegate in delegates {
            delegate.canvasUpdated()
        }
    }
}
