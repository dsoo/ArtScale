//
//  RenderedStrokeViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

// Handles user input that adds additional stroke information to the ArtModel
// Filters out multitouch events, only takes in pencil events
// In the future will pass UI state into the StrokeInputHandler

import CleanroomLogger
import UIKit

protocol CanvasViewControllerProtocol {
    // FIXME: Protocol should not expose this
    
    var canvasViewModel: CanvasViewModel {get}
}

final class CanvasViewController: UIViewController, CanvasViewControllerProtocol {
    @IBOutlet var canvasView: CanvasView!
    var canvasViewModel: CanvasViewModel = CanvasViewModel()

    private var stroke = Stroke(points: [])

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        canvasViewModel.canvasView = canvasView
        canvasView.canvasViewModel = canvasViewModel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //
    // Input handling
    //
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        stroke.points = []
        for touch in touches {
            let l = touch.location(in: canvasView)
            stroke.points.append(Point(x: Double(l.x), y: Double(l.y)))
        }

        canvasViewModel.startStroke(stroke: stroke)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            let l = touch.location(in: canvasView)
            stroke.points.append(Point(x: Double(l.x), y: Double(l.y)))
        }
        canvasViewModel.updateStroke(stroke: stroke)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            let l = touch.location(in: canvasView)
            stroke.points.append(Point(x: Double(l.x), y: Double(l.y)))
        }

        canvasViewModel.endStroke(stroke: stroke)
        stroke.points = []
    }
}
