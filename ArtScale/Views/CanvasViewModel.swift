//
//  RenderedStrokeViewModel.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation
import CleanroomLogger

class CanvasViewModel: P2PStateLocalObserver {
    private var canvasModel: CanvasModel?
    var renderer: CanvasViewRenderer?
    var renderedStrokes: [Stroke] = []

    init() {
    }

    public func configure(canvasModel: CanvasModel) {
        self.canvasModel = canvasModel
        canvasModel.localObservers.append(self)
    }

    //
    // View data update methods
    //

    func p2pStateUpdate(p2pState: P2PState) {
        // Transform the "abstract" strokes coming from the model into "rendering strokes"
        // Tell the UI to redraw based on the rendering strokes in the controller

        // FIXME: Get CanvasModel from func?
        // FIXME: Being lazy and just directly passing stroke data to renderer for now
        renderedStrokes = canvasModel!.allStrokes()

        // Update all of the renderer information
        renderer?.updateVertexData()
    }

    // Model mutation methods
    func startStroke(stroke _: Stroke) {}

    func updateStroke(stroke _: Stroke) {}

    func endStroke(stroke: Stroke) {
        canvasModel?.addStroke(stroke: stroke)
    }
}
