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
    private var canvasManager: CanvasManager?
    var renderer: CanvasViewRenderer?
    var renderedStrokes: [Stroke] = []

    var canvas: Canvas {
        return canvasManager!.canvas
    }

    var currentLayerID: LayerID {
        if canvas.orderedLayers.count > 0 {
            return canvas.orderedLayers.last!
        }
        return canvas.addLayer().id
    }

    var currentStroke: Stroke?

    init() {
    }

    public func configure(canvasManager: CanvasManager) {
        self.canvasManager = canvasManager
        canvasManager.localObservers.append(self)
    }

    //
    // View data update methods
    //

    func p2pStateUpdate(p2pState: P2PStateManager) {
        // Transform the "abstract" strokes coming from the model into "rendering strokes"
        // Tell the UI to redraw based on the rendering strokes in the controller

        // FIXME: Get CanvasManager from func?
        // FIXME: Being lazy and just directly passing stroke data to renderer for now
        renderedStrokes = canvasManager!.allStrokes()

        // Update all of the renderer information
        renderer?.updateVertexData()
    }

    // Model mutation methods
    func startStroke(_ point: Point) {
        currentStroke = Stroke(layerID: currentLayerID, canvas: canvasManager!.canvas)
    }

    func updateStroke(_ point: Point) {
        currentStroke!.addPoint(point: point)
    }

    func endStroke(_ point: Point) {
        canvasManager?.addStroke(stroke: currentStroke!)
        currentStroke = nil
    }
}
