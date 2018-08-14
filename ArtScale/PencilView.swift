//
//  PencilView.swift
//  ArtScale
//
//  Created by Douglas Soo on 8/8/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import UIKit

class PencilView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = true
    }
    
    override func draw(_ rect: CGRect) {
        print("PencilView draw")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
            NSAttributedStringKey.foregroundColor: UIColor.blue
        ]
        
        let myText = "HELLO"
        let attributedString = NSAttributedString(string: myText, attributes: attributes)
        
        let stringRect = CGRect(x: 50, y: 50, width: 100, height: 100)
        attributedString.draw(in: stringRect)
    }
}
