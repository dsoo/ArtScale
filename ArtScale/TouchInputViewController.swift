//
//  TouchInputViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

// Handles user input that adds additional stroke information to the ArtModel
// Filters out multitouch events, only takes in pencil events
// In the future will pass UI state into the StrokeInputHandler


import UIKit

final class TouchInputViewController: UIViewController {
    
    private let strokeInputHandler: StrokeInputHandler
    
    init(strokeInputHandler: StrokeInputHandler) {
        self.strokeInputHandler = strokeInputHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        print("TouchInputViewController init coder")
        // FIXME: This should initialize someplace better
        self.strokeInputHandler = StrokeModelInputHandler()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        print("TouchInputViewController viewDidLoad")
        super.viewDidLoad()
        
        // Load the current state from the model
        strokeInputHandler.syncState()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        strokeInputHandler.startStroke()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesMoved")
        strokeInputHandler.updateStroke()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        strokeInputHandler.endStroke()
    }
    
}
