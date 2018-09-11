//
//  TouchInputHandler.swift
//  ArtScale
//
// Handles touch events coming from the UI and translates them into strokes and
// adding them to the model.
//
//  Created by Douglas Soo on 9/10/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import Foundation

protocol TouchInputHandler: class {
    func syncState()
    func startTouch()
    func endTouch()
}
