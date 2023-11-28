//
//  ImageProcessor.swift
//  SudokuScanner
//
//  Created by Loc Tran on 26/03/2023.
//

import Foundation
import UIKit
import CoreImage
import Vision

typealias ImageProcessorCompletion = (UIImage?) -> Void

class ImageProcessor {
    
    var adjustValue: CGFloat = 0.5
    
    func process(image: UIImage, completion: ImageProcessorCompletion?) {
        DispatchQueue.executeOnBackground { [weak self] in
            let preprocessResult = self?.preprocessImage(image)
            return preprocessResult
        } completionOnMain: { preprocessResult in
            if let result = preprocessResult {
                completion?(result)
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

    func findContours(in image: UIImage) {
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else {
            print("Error converting UIImage to CIImage")
            return
        }

        // Create a request for the Vision framework
        let request = VNDetectContoursRequest()

        // Perform the request using a Vision sequence handler
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        do {
            try handler.perform([request])
        } catch {
            print("Error performing Vision request: \(error)")
            return
        }

        // Retrieve the results from the request
        guard let observations = request.results else {
            print("No contour observations found")
            return
        }
        
        // Process the contour observations
        for observation in observations {
            // Each observation may contain multiple contours
            for contour in observation.topLevelContours {
                // `contour.normalizedPoints` contains the normalized points of the contour
                // You can process or visualize the contours as needed
                print("Contour points: \(contour.normalizedPoints)")
            }
        }
    }
}
