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

        let leftCM = CanvasModel()
        let rightCM = CanvasModel()
        leftCM.serializedDelegates.append(rightCM)
        rightCM.serializedDelegates.append(leftCM)

        left.canvasViewModel.configure(canvasModel: leftCM)
        right.canvasViewModel.configure(canvasModel: rightCM)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
