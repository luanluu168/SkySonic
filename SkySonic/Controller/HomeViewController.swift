//
//  HomeViewController.swift
//  SkySonic
//
//  Created by Luan Luu on 11/9/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.makePillShape()
    }
    
}
