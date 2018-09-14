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

final class CanvasViewController: UIViewController {
    @IBOutlet var canvasView: CanvasView!
    private var canvasViewModel: CanvasViewModel = CanvasViewModel()

    private var locations: [CGPoint] = []

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info?.trace()
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
        Log.info?.trace()
        for touch in touches {
            let l = touch.location(in: nil)
            locations.append(l)
        }
        let s = Stroke(points: locations)
        canvasViewModel.startStroke(stroke: s)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            let l = touch.location(in: nil)
            locations.append(l)
        }
        let s = Stroke(points: locations)
        canvasViewModel.updateStroke(stroke: s)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            let l = touch.location(in: nil)
            locations.append(l)
        }

        let s = Stroke(points: locations)
        canvasViewModel.endStroke(stroke: s)
        locations.removeAll()
    }
}
