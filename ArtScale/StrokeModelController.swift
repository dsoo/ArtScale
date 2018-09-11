//
//  ArtModelController.swift
//  ArtScale
//
// Handles all interactions/model updates between the StrokeModel and UI/Network
//
//  Created by Douglas Soo on 8/13/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

// Retrieves ArtModel data from wherever it exists (disk, network, etc.) and manages all updates of the data
// based on network or user input

import Foundation

enum StrokeModelState {
    // Placeholder for actual model state
}

protocol StrokeModelDelegate: class {
    var state: StrokeModelState {get set}
}

final class StrokeModelController {
////    var delegate: StrokeModelDelegate?
//    func syncState() {
//        // Do some stuff to retrieve the latest state of the model
//        print("StrokeModelController syncState()")
//    }
//    
//    func startTouch() {
//        print("StrokeModelController startTouch")
//    }
//    
//    func endTouch() {
//        print("StrokeModelController endTouch")
//    }
}
