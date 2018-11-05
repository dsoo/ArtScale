//
//  CanvasViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/26/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import MetalKit
import UIKit
import CleanroomLogger

class CanvasViewController: UIViewController {
    @IBOutlet var mtkView: MTKView!

    var renderer: CanvasViewRenderer!
    var device: MTLDevice?

    var canvasViewModel: CanvasViewModel = CanvasViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        device = MTLCreateSystemDefaultDevice()
        // FIXME: Is it okay to do this once per view?
        mtkView.device = device
        mtkView.colorPixelFormat = .bgra8Unorm
        renderer = CanvasViewRenderer(view: mtkView, device: device!, canvasViewModel: canvasViewModel)
        canvasViewModel.renderer = renderer
        mtkView.delegate = renderer
    }

    func configure(device: MTLDevice?) {
        Log.info?.trace()
        self.device = device
    }

    //
    // Input handling
    //
    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        let p = Point(x: 0.0, y: 0.0)
        for touch in touches {
            let l = touch.location(in: mtkView)
            p.x = Double(l.x)
            p.y = Double(l.y)
        }
        canvasViewModel.startStroke(p)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let p = Point(x: 0.0, y: 0.0)
        for touch in touches {
            let l = touch.location(in: mtkView)
            p.x = Double(l.x)
            p.y = Double(l.y)
        }
        canvasViewModel.updateStroke(p)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        let p = Point(x: 0.0, y: 0.0)
        for touch in touches {
            let l = touch.location(in: mtkView)
            p.x = Double(l.x)
            p.y = Double(l.y)
        }
        canvasViewModel.endStroke(p)
    }}
