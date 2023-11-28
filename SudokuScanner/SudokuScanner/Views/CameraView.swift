//
//  CameraView.swift
//  SudokuScanner
//
//  Created by Loc Tran on 26/03/2023.
//

import UIKit
import AVFoundation

protocol CameraViewDelegate: AnyObject {
    func cameraView(_ view: CameraView, didCapture image: UIImage)
}

class CameraView: UIView {

    // MARK: - Properties

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var captureDevice: AVCaptureDevice?

    weak var delegate: CameraViewDelegate?

    // MARK: - Methods

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        // Stop the capture session when the view controller is deallocated
        captureSession.stopRunning()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        previewLayer.frame = bounds
    }

    private func setupLayout() {

        // Tap on preview layer to focus
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focus(_:)))
        addGestureRecognizer(tapGesture)

        // Get the back camera input device
        guard let videoDevice = AVCaptureDevice.default(.builtInDualCamera,
                                                        for: .video,
                                                        position: .back) else {
            return
        }
        captureDevice = videoDevice

        do {
            // Create a device input from the back camera
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)

            // Add the device input to the capture session
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            } else {
                return
            }

            // Create a video data output and set it to run on the main queue
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(self,
                                                    queue: DispatchQueue.main)

            // Add the video data output to the capture session
            if captureSession.canAddOutput(videoDataOutput) {
                captureSession.addOutput(videoDataOutput)
            } else {
                return
            }

            // Set the video orientation to portrait
            videoDataOutput.connection(with: .video)?.videoOrientation = .portrait

            // Create a preview layer and add it to the view's layer
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(previewLayer)

            // Start the capture session
            DispatchQueue.global().async { [weak self] in
                self?.captureSession.startRunning()
            }

        } catch {
            // Handle any errors
            print(error)
            return
        }
    }

    private func startAnimationWhenFocus(at point: CGPoint) {
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        circle.center = point
        circle.layer.cornerRadius = 50
        circle.layer.borderWidth = 2
        circle.layer.borderColor = UIColor.white.cgColor
        circle.alpha = 0.0
        addSubview(circle)

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.1
        animation.autoreverses = true
        animation.repeatCount = 3

        UIView.animate(withDuration: 0.3, animations: {
            circle.alpha = 1.0
        }, completion: { _ in
            circle.removeFromSuperview()
        })

        circle.layer.add(animation, forKey: "twinkleAnimation")
    }

    @objc private func focus(_ tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(in: self)
        let convertedFocusPoint = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
        do {
            try captureDevice?.lockForConfiguration()
            captureDevice?.focusPointOfInterest = convertedFocusPoint
            captureDevice?.focusMode = .autoFocus
            captureDevice?.unlockForConfiguration()

            startAnimationWhenFocus(at: point)
        } catch {
            print("Failed to focus")
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {

    private func renderImage(from pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }

    // AVCaptureVideoDataOutputSampleBufferDelegate method that gets called when a new video frame is available
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {

        // video data
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!

        //
        if let image = renderImage(from: pixelBuffer) {
            delegate?.cameraView(self, didCapture: image)
        }
    }
}
