//
//  VNContour+Extensions.swift
//  SudokuScanner
//
//  Created by azibai loc on 29/11/2023.
//

import Vision

extension VNContour {
    
    var boundingBox: CGRect {
        var minX: Float = 1.0
        var minY: Float = 1.0
        var maxX: Float = 0.0
        var maxY: Float = 0.0
        
        for point in normalizedPoints {
            if point.x < minX {
                minX = point.x
            } else if point.x > maxX {
                maxX = point.x
            }
            
            if point.y < minY {
                minY = point.y
            } else if point.y > maxY {
                maxY = point.y
            }
        }
        
        return CGRect(
            x: Double(minX),
            y: Double(minY),
            width: Double(maxX - minX),
            height: Double(maxY - minY))
    }
    
    func point(in rect: CGRect) -> [CGPoint] {
        return normalizedPoints.map {
            CGPoint(x: CGFloat($0.x) * rect.size.width + rect.origin.x,
                    y: rect.size.height - CGFloat($0.y) * rect.size.height + rect.origin.y)
        }
    }
    
    func getBoundingBox(accordingTo size: CGSize) -> CGRect {
        return CGRect(x: boundingBox.origin.x * size.width,
                      y: boundingBox.origin.y * size.height,
                      width: boundingBox.size.width * size.width,
                      height: boundingBox.size.height * size.height)
    }
    
    func intersectionOverUnion(with contour: VNContour) -> Float {
        let intersection = boundingBox.intersection(contour.boundingBox).area
        let union = boundingBox.area + contour.boundingBox.area - intersection
        return Float(intersection / union)
    }
}
