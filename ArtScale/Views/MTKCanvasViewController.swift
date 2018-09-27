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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = MTLCreateSystemDefaultDevice()
        mtkView.device = device
        mtkView.colorPixelFormat = .bgra8Unorm
        renderer = CanvasViewRenderer(view: mtkView, device: device!)
        mtkView.delegate = renderer
    }    
}

