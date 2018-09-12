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


import UIKit

final class RenderedStrokeViewController: UIViewController, StrokeModelWatcherDelegate {
    
    private let strokeModel = StrokeModel()
    private var strokeInputHandler: StrokeInputHandler?
    private var locations: [CGPoint] = []
    
    // FIXME: Must be a better way to do this than to cast in a computed type
    var rsView: RenderedStrokeView! { return self.view as! RenderedStrokeView }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: This should initialize someplace better
        strokeModel.delegate = self
        let smih = StrokeModelInputHandler(strokeModel: strokeModel)
        strokeInputHandler = smih
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    // Stroke updates
    //
    
    func strokesUpdated() {
        // Transform the "abstract" strokes coming from the model into "rendering strokes"
        // Tell the UI to redraw based on the rendering strokes in the controller
        // FIXME: Being lazy and just directly passing stroke data to renderer for now
        rsView.renderedStrokes = strokeModel.allStrokes()
        view.setNeedsDisplay()
    }
    
    //
    // Input handling
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let l = touch.location(in:nil)
            locations.append(l)
        }
        let s = Stroke(points:locations)
        strokeInputHandler?.startStroke(stroke:s)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let l = touch.location(in:nil)
            locations.append(l)
        }
        let s = Stroke(points:locations)
        strokeInputHandler?.updateStroke(stroke:s)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let l = touch.location(in:nil)
            locations.append(l)
        }

        let s = Stroke(points:locations)
        strokeInputHandler?.endStroke(stroke:s)
        locations.removeAll()
    }
    
}
