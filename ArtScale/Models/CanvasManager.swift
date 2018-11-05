//
//  CanvasManager.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import CleanroomLogger
import Foundation

// Maintains application state surrounding the canvas that isn't the actual canvas itself, e.g.
// current layers, etc.
class CanvasManager: P2PStateManager {
    var localObservers: [P2PStateLocalObserver] = []
    var remoteObservers: [P2PStateRemoteObserver] = []
    static var decodeStateManager: P2PStateManager? {
        return decodeCanvasManager
    }
    static var decodeCanvasManager: CanvasManager?

    lazy var canvas: Canvas = Canvas(canvasManager: self)

    func allStrokes() -> [Stroke] {
        return canvas.allStrokes()
    }

    func addStroke(stroke: Stroke) {
        canvas.addStroke(stroke)
        updateAllObservers()
    }

    func p2pStateMakeFullUpdate(p2pState: P2PStateManager) -> Data {
        // FIXME: Error handling!
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(canvas)
            return jsonData
        } catch {
            return String("{}").data(using: .utf8)!
        }
    }

    func p2pStateApplyFullUpdate(p2pState: P2PStateManager, fullUpdate: Data) {
        // Received a state update from a remote canvas, update our state
        // FIXME: Error handling!
        do {
            canvas = try decodeNode(Canvas.self, from: fullUpdate)
        } catch {
            Log.error?.message("Failed to decode canvas")
        }
    }
}
