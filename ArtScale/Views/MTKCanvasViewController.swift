//
//  MTKCanvasViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/26/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import MetalKit
import UIKit
import CleanroomLogger

class MTKCanvasViewController: UIViewController, CanvasViewControllerProtocol {
    @IBOutlet var mtkView: MTKView!
    var renderer: CanvasViewRenderer!

    var canvasViewModel: CanvasViewModel = CanvasViewModel()
    private var stroke = Stroke(points: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        let device = MTLCreateSystemDefaultDevice()
        mtkView.device = device
        mtkView.colorPixelFormat = .bgra8Unorm
        renderer = CanvasViewRenderer(view: mtkView, device: device!, canvasViewModel: canvasViewModel)
        mtkView.delegate = renderer
    }

    //
    // Input handling
    //
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        Log.info?.value(mtkView)
        stroke.points = []
        for touch in touches {
            let l = touch.location(in: mtkView)
            stroke.points.append(Point(x: Double(l.x), y: Double(l.y)))
        }

        canvasViewModel.startStroke(stroke: stroke)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            let l = touch.location(in: mtkView)
            stroke.points.append(Point(x: Double(l.x), y: Double(l.y)))
        }
        canvasViewModel.updateStroke(stroke: stroke)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        for touch in touches {
            let l = touch.location(in: mtkView)
            stroke.points.append(Point(x: Double(l.x), y: Double(l.y)))
        }

        canvasViewModel.endStroke(stroke: stroke)
        stroke.points = []
    }}
