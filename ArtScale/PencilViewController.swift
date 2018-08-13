//
//  PencilViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

// Handles user input that adds additional stroke information to the ArtModel
// Renders the current state based on the ArtModel
// Generically implements this without worrying about the mechanics of how the model is retrieved and updated

import UIKit

final class PencilViewController: UIViewController {
    
    private let artModelHandler: ArtModelHandler
    private var artModelUIController: ArtModelUIController!
    
    init(artModelHandler: ArtModelHandler) {
        self.artModelHandler = artModelHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        self.artModelHandler = ArtModelController()
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        print("PencilViewController viewDidLoad")
        super.viewDidLoad()
        
        artModelUIController = ArtModelUIController(view: view)
        artModelHandler.delegate = artModelUIController
        
        artModelHandler.fetchArtModel()
    }
}
