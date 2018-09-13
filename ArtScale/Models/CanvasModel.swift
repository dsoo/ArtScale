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

protocol CanvasModelWatcherDelegate: class {
    func canvasUpdated()
}

protocol CanvasModelDelegate: class {
    func addStroke(stroke: Stroke)
}

class CanvasModel: CanvasModelDelegate {
    weak var delegate: CanvasModelWatcherDelegate?
    
    private var strokes: [Stroke] = []

    func allStrokes() -> [Stroke] {
        return strokes
    }
    
    func addStroke(stroke: Stroke) {
        strokes.append(stroke)
        delegate?.canvasUpdated()
    }
}
