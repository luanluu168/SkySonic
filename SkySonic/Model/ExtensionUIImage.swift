//
//  ResizeUIImage.swift
//  SkySonic
//
//  Created by Luan Luu on 11/8/20.
//  Copyright © 2020 Luan Luu. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImageToSmaller(_ width: CGFloat) -> UIImage? {
        var rect: CGRect?
        var widthRatio: CGFloat = 0
        let previousWidth = self.size.width
        // if the desired width is larger than the previous width, just return it self
        if previousWidth < width {
            return self
        }
        
        // otherwise, make it smaller
        widthRatio = width / previousWidth.significand
        let   size = CGSize(width: widthRatio, height: widthRatio)
        let OPAQUE = false
        UIGraphicsBeginImageContextWithOptions(size, OPAQUE, scale)
        rect = CGRect(origin: .zero, size: size)
        if let validRect = rect {
            self.draw(in: validRect)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
