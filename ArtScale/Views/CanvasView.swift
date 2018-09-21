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
    weak var canvasViewModel: CanvasViewModel?

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
        // FIXME: Probably just need a guard around canvasViewModel, or to understand how to guarantee a canvasViewModel
        let renderedStrokes = canvasViewModel != nil ? canvasViewModel?.renderedStrokes : []
        for stroke in (renderedStrokes)! {
            var first = true
            for point in stroke.points {
                if !first {
                    context.addLine(to: CGPoint(x: point.x, y: point.y))
                } else {
                    context.beginPath()
                    context.move(to: CGPoint(x: point.x, y: point.y))
                    first = false
                }
            }
            context.strokePath()
        }
    }
}
