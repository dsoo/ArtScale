//
//  MultiViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/20/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import CleanroomLogger
import UIKit

final class MultiViewController: UIViewController {
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info?.trace()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
