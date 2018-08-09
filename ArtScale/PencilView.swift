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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan", touches)
    }
}
