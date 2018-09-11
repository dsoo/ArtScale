//
//  StrokeModelInputHandler.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/10/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation

final class StrokeModelInputHandler: TouchInputHandler {
    var delegate: StrokeModelDelegate?
    
    func syncState() {
        // Do some stuff to retrieve the latest state of the model
        print("StrokeModelInputHandler syncState()")
    }
    
    func startTouch() {
        print("StrokeModelInputHandler startTouch")
    }
    
    func endTouch() {
        print("StrokeModelInputHandler endTouch")
        print("StrokeModelInputHandler creates new stroke")
    }
}
