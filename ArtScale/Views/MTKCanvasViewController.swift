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

class MTKCanvasViewController: UIViewController, MTKViewDelegate, CanvasViewControllerProtocol {
    var canvasViewModel: CanvasViewModel = CanvasViewModel()

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        Log.info?.trace()
    }
    func draw(in view: MTKView) {
        Log.info?.trace()
    }
}

