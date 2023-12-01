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
        
        var contours: [VNContour] = []
        
        guard let cgImage = image.cgImage else {
            print("Error converting UIImage to CGImage")
            return nil
        }
        
        let detector = ContourDetector.shared

        detector.set(epsilon: UserDefaults.standard.epsilon)
        
//        let strideAmount: Float = 0.2
//        let adjustStride = stride(
//          from: max(UserDefaults.standard.adjustment - strideAmount, 0),
//          to: UserDefaults.standard.adjustment + strideAmount,
//          by: 0.2)
//
//        for adjustment in adjustStride {
//          detector.set(contrastAdjustment: adjustment)
//
//          let newContours = (try? detector.process(image: cgImage)) ?? []
//
//          contours.append(contentsOf: newContours)
//        }
        
        detector.set(contrastAdjustment: UserDefaults.standard.adjustment)

        let newContours = (try? detector.process(image: cgImage)) ?? []

        contours.append(contentsOf: newContours)

        if contours.count < 9000 {
          let threshold = UserDefaults.standard.threshold

          var pos = 0
          while pos < contours.count {
            let contour = contours[pos]
            contours = contours[0...pos] + contours[(pos + 1)...].filter {
              contour.intersectionOverUnion(with: $0) < threshold
            }
            pos += 1
          }
        }
        
//        var imageResult = drawContours(on: image, with: contours)
//
//        if let unwrappedResult = imageResult,
//            let largestSquareContour = findLargestSquareContour(from: contours) {
//            imageResult = drawContours(on: unwrappedResult, with: [largestSquareContour], color: .red)
//        }
        
        if let largestSquareContour = findLargestSquareContour(from: contours) {
            let rect = largestSquareContour.getBoundingBox(accordingTo: image.size)
            let cropped = image.crop(rect: rect)
            return cropped
        }
        
        return nil
    }
    
    func drawContours(on image: UIImage, with contours: [VNContour], color: UIColor = .white) -> UIImage? {
        // Begin an image context to draw on
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }

        // Draw the original image
        image.draw(at: .zero)
        
        // Get the current context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // Create blank canvas
//        context.setFillColor(UIColor.black.cgColor)
//        context.fill(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        // Set the line color and width
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(2.0)
        
        for contour in contours {
            
            // Convert VNContour points to CGPoint
            let cgPoints = contour.point(in: CGRect(origin: .zero, size: image.size))

            // Draw the contour path
            context.addLines(between: cgPoints)
            context.closePath()
            context.strokePath()

        }
        
        // Retrieve the drawn image from the context
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func findLargestSquareContour(from contours: [VNContour]) -> VNContour? {
        var largestSquareContour: VNContour?
        var maxArea: Float = 0.0

        for contour in contours {
            // Check if the contour is approximately square
            let boundingBox = contour.boundingBox
            let aspectRatio = contour.aspectRatio
            let area: Float = Float(boundingBox.area)
            let aspectRatioThreshold: Float = 0.2

            if aspectRatio > 1 - aspectRatioThreshold && aspectRatio < 1 + aspectRatioThreshold {
                // The contour is approximately square

                // Check if it has the maximum area so far
                if area > maxArea {
                    maxArea = area
                    largestSquareContour = contour
                }
            }
        }

        return largestSquareContour
    }
}
