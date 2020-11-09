//
//  ExtensionUIButton.swift
//  SkySonic
//
//  Created by Luan Luu on 11/9/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import UIKit

extension UIButton {
    func makePillShape() {
            // if the button already has a pill shape, do nothing
            if (self.layer.borderWidth == 1.0) { return }
            
            self.layer.borderWidth   = 1.0
            self.layer.borderColor   = UIColor.cyan.cgColor
            self.layer.cornerRadius = frame.size.height/2
            self.setTitleColor(UIColor.white, for: .highlighted)
    }
}
