//
//  ArtModelUIController.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import UIKit

final class ArtModelUIController {
    
    private unowned var view: UIView
    
    var state: ArtModelUIState = .Loading {
        willSet(newState) {
            update(newState: newState)
        }
    }
    
    init(view: UIView) {
        // Initialize the PencilView with data
        // Set the pencilView's data source to be the based on the data
        self.view = view
        update(newState: state)
    }
}

extension ArtModelUIController: ArtModelDelegate {
    
    func update(newState: ArtModelUIState) {
        
        switch(state, newState) {
        case (.Loading, .Loading): loadingToLoading()
        case (.Loading, .Success(let artModel)): loadingToSuccess(artModel: artModel)
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    func loadingToLoading() {
    }
    
    func loadingToSuccess(artModel: ArtModel) {
        // Do some stuff to update the UI state based on the incoming data
    }
}
