//
//  AppViewController.swift
//  ArtScale
//
//  Created by Douglas Soo on 9/20/18.
//  Copyright © 2018 Scalable Interfaces LLC. All rights reserved.
//

import CleanroomLogger
import UIKit

final class AppViewController: UIViewController {
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let left = self.children[0] as! CanvasViewController
        let right = self.children[1] as! CanvasViewController

        let ad = UIApplication.shared.delegate as! AppDelegate

        left.canvasViewModel.configure(canvasModel: ad.leftCM!)
        right.canvasViewModel.configure(canvasModel: ad.rightCM!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
