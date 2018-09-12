//
//  StrokeModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import UIKit

struct Stroke {
    var points: [CGPoint]
}

protocol StrokeModelWatcherDelegate: class {
    func strokesUpdated()
}

protocol StrokeModelDelegate: class {
    func addStroke(stroke: Stroke)
}

class StrokeModel: StrokeModelDelegate {
    weak var delegate: StrokeModelWatcherDelegate?
    
    private var strokes: [Stroke] = []

    func allStrokes() -> [Stroke] {
        return strokes
    }
    
    func addStroke(stroke: Stroke) {
        strokes.append(stroke)
        delegate?.strokesUpdated()
    }
}
