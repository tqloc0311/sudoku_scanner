//
//  ImageProcessor.swift
//  SudokuScanner
//
//  Created by Loc Tran on 26/03/2023.
//

import Foundation
import UIKit
import CoreImage

typealias ImageProcessorCompletion = (UIImage?) -> Void

class ImageProcessor {
    
    var adjustValue: CGFloat = 0.5
    
    func process(image: UIImage, completion: ImageProcessorCompletion?) {
        DispatchQueue.global().async { [weak self] in
            let preprocessResult = self?.preprocessImage(image)
            DispatchQueue.main.async {
                completion?(preprocessResult)
            }
        }
    }
    
    private func preprocessImage(_ image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let context = CIContext()
        
        // Convert the image to grayscale
        let grayFilter = CIFilter(name: "CIPhotoEffectMono")
        grayFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let grayImage = grayFilter?.outputImage else { return nil }

        // Finds all edges in image
        let edgesFilter = CIFilter(name: "CIEdges")
        edgesFilter?.setValue(grayImage, forKey: kCIInputImageKey)
        guard let edgesDetected = edgesFilter?.outputImage else { return nil }
        
        let noiseReductionFilter = CIFilter(name: "CINoiseReduction")
        noiseReductionFilter?.setValue(edgesDetected, forKey: kCIInputImageKey)
//        noiseReductionFilter?.setValue(adjustValue, forKey: "inputNoiseLevel")
        noiseReductionFilter?.setValue(adjustValue, forKey: "inputSharpness")
        guard let noiseReduced = noiseReductionFilter?.outputImage else { return nil }
        
        // Convert the processed image to a UIImage and return it
        guard let cgImage = context.createCGImage(noiseReduced, from: noiseReduced.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }

}
