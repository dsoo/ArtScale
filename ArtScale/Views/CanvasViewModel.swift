//
//  RenderedStrokeViewModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import CleanroomLogger

class CanvasViewModel: CanvasModelDelegate {
    weak var canvasView: CanvasView?
    private var canvasModel: CanvasModel
    var renderedStrokes: [Stroke] = []

    init() {
        canvasModel = CanvasModel()
        canvasModel.delegate = self
    }

    //
    // View data update methods
    //

    // CanvasModelDelegate implementation
    func canvasUpdated() {
        // Transform the "abstract" strokes coming from the model into "rendering strokes"
        // Tell the UI to redraw based on the rendering strokes in the controller
        // FIXME: Being lazy and just directly passing stroke data to renderer for now
        renderedStrokes = canvasModel.allStrokes()
        Log.info?.trace()
        canvasView?.setNeedsDisplay()
    }

    // Model mutation methods
    func startStroke(stroke _: Stroke) {}

    func updateStroke(stroke _: Stroke) {}

    func endStroke(stroke: Stroke) {
        Log.info?.trace()
        canvasModel.addStroke(stroke: stroke)
    }
}
