//
//  UIImage+Extensions.swift
//  SudokuScanner
//
//  Created by azibai loc on 01/12/2023.
//

import UIKit

extension UIImage {
    func centerSquareCropping(percentage: CGFloat) -> UIImage? {
        guard percentage > 0 && percentage <= 1,
                let image = cgImage else { return nil }
        let refWidth = CGFloat(image.width)
        let refHeight = CGFloat(image.height)
        var cropSize = refWidth > refHeight ? refHeight : refWidth
        cropSize *= percentage
        
        let cropX = (refWidth - cropSize) / 2.0
        let cropY = (refHeight - cropSize) / 2.0
        
        let cropRect = CGRect(x: cropX, y: cropY, width: cropSize, height: cropSize)
        return crop(rect: cropRect)
    }
    
    func crop(rect: CGRect) -> UIImage? {
        guard let image = cgImage,
                let imageRef = image.cropping(to: rect) else { return nil }
        let cropped = UIImage(cgImage: imageRef, scale: 0.0, orientation: imageOrientation)
        return cropped
    }
}
