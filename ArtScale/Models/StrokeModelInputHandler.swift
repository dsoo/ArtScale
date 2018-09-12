//
//  StrokeModelInputHandler.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/10/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation

final class StrokeModelInputHandler: StrokeInputHandler {
    var delegate: StrokeModelDelegate?
    
    required init(strokeModel: StrokeModelDelegate) {
        delegate = strokeModel
    }
    
    func syncState() {
        // Do some stuff to retrieve the latest state of the model
    }
    
    func startStroke(stroke: Stroke) {
    }

    func updateStroke(stroke: Stroke) {
    }

    func endStroke(stroke: Stroke) {
        delegate?.addStroke(stroke: stroke)
    }
}
