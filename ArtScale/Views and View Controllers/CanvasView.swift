//
//  PencilView.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/8/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import UIKit

// struct RenderedStroke {
//    let points: [CGPoint] = []
// }

protocol RenderedStrokeDataSource {}

class CanvasView: UIView {
    var renderedStrokes: [Stroke] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = true
    }

    override func draw(_: CGRect) {
        let color = UIColor.black
        let brushWidth: CGFloat = 10.0

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)

        // Iterate through renderedStrokes and draw the lines
        for stroke in renderedStrokes {
            var first = true
            for point in stroke.points {
                if !first {
                    context.addLine(to: point)
                } else {
                    context.beginPath()
                    context.move(to: point)
                    first = false
                }
            }
            context.strokePath()
        }
    }
}
