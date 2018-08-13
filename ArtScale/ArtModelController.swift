//
//  ArtModelController.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

// Retrieves ArtModel data from wherever it exists (disk, network, etc.) and manages all updates of the data
// based on network or user input

import Foundation

enum ArtModelUIState {
    // State of the UI
    case Loading
    case Success(ArtModel)
    case Failure(Error)
}

protocol ArtModelDelegate: class {
    var state: ArtModelUIState {get set}
}

protocol ArtModelHandler: class {
    
    var delegate: ArtModelDelegate? { get set }
    func fetchArtModel()
}

final class ArtModelController: ArtModelHandler {
    var delegate: ArtModelDelegate?
    func fetchArtModel() {
        // Do some stuff to get the state of the ArtModel
        print("ArtModelController fetchArtModel()")
    }
}
