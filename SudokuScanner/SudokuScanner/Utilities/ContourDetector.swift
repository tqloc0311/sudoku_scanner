//
//  ContourDetector.swift
//  SudokuScanner
//
//  Created by azibai loc on 29/11/2023.
//

import Vision

class ContourDetector {
    static let shared = ContourDetector()
    
    private var epsilon: Float = 0.001
    private lazy var request: VNDetectContoursRequest = {
        let req = VNDetectContoursRequest()
        return req
    }()
    
    private init() {}
    
    private func postProcess(request: VNRequest) -> [VNContour] {
        guard let results = request.results as? [VNContoursObservation] else {
            return []
        }
        
        let vnContours = results.flatMap { contour in
            (0..<contour.contourCount).compactMap { try? contour.contour(at: $0) }
        }
        let simplifiedContours = vnContours.compactMap {
            try? $0.polygonApproximation(epsilon: self.epsilon)
        }
        
        return simplifiedContours
    }
    
    private func perform(_ request: VNRequest, on image: CGImage) throws -> VNRequest {
        let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        try requestHandler.perform([request])
        return request
    }
    
    func process(image: CGImage?) throws -> [VNContour] {
        guard let image = image else {
            return []
        }
        
        let contourRequest = try perform(request, on: image)
        
        return postProcess(request: contourRequest)
    }
    
    func set(epsilon: Float) {
        self.epsilon = epsilon
    }
    
    func set(contrastAdjustment: Float) {
        request.contrastAdjustment = contrastAdjustment
    }
}
