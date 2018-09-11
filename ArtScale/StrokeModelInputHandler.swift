//
//  StrokeModelInputHandler.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/10/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation

final class StrokeModelInputHandler: StrokeInputHandler {
    var delegate: StrokeModelDelegate?
    
    func syncState() {
        // Do some stuff to retrieve the latest state of the model
        print("StrokeModelInputHandler syncState()")
    }
    
    func startStroke() {
        print("StrokeModelInputHandler startStroke")
    }

    func updateStroke() {
        print("StrokeModelInputHandler updateStroke")
    }

    func endStroke() {
        print("StrokeModelInputHandler endStroke")
        print("StrokeModelInputHandler creates new stroke")
    }
}
