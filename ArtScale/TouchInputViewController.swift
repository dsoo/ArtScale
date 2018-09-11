//
//  TouchInputViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

// Handles user input that adds additional stroke information to the ArtModel
// Renders the current state based on the ArtModel
// Generically implements this without worrying about the mechanics of how the model is retrieved and updated

import UIKit

final class TouchInputViewController: UIViewController {
    
    private let touchInputHandler: TouchInputHandler
    
    init(touchInputHandler: TouchInputHandler) {
        self.touchInputHandler = touchInputHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        print("TouchInputViewController init coder")
        self.touchInputHandler = StrokeModelInputHandler()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        print("TouchInputViewController viewDidLoad")
        super.viewDidLoad()
        
        // Load the current state from the model
        touchInputHandler.syncState()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        touchInputHandler.startTouch()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesMoved")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        touchInputHandler.endTouch()
    }
    
}
