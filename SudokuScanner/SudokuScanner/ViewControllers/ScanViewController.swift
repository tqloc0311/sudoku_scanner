//
//  ScanViewController.swift
//  SudokuScanner
//
//  Created by Loc Tran on 26/03/2023.
//

import Foundation
import UIKit
import AVFoundation

class ScanViewController: UIViewController {
    
    // MARK: - Outlets
    
    private let closeButton = UIButton(type: .system)
    private let cameraView = CameraView(frame: .zero)
    private let previewImageView = UIImageView(frame: .zero)
    private let slider = UISlider(frame: .zero)
    private let sliderLabel = UILabel(frame: .zero)
    
    // MARK: - Properties
    lazy var processor: ImageProcessor = {
        return ImageProcessor()
    }()
    
    // MARK: - Methods
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        // add camera view
        view.addSubview(cameraView)
        cameraView.delegate = self
        cameraView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // preview image
        view.addSubview(previewImageView)
        previewImageView.layer.cornerRadius = 4
        previewImageView.layer.borderColor = UIColor.white.cgColor
        previewImageView.layer.borderWidth = 1
        previewImageView.clipsToBounds = true
        previewImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(1.0 / 3.0)
            make.height.equalToSuperview().multipliedBy(1.0 / 3.0)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.edges.equalToSuperview()
        }
        
        view.addSubview(slider)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0.5
        slider.addTarget(self, action: #selector(sliderValueChangedHandler(_:)), for: .valueChanged)
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
//            make.bottom.equalTo(previewImageView.snp.top).inset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        view.addSubview(sliderLabel)
        sliderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(slider.snp.top).inset(-16)
        }
        
        // close button
        view.addSubview(closeButton)
        closeButton.setImage(.init(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonHandler), for: .touchUpInside)
        closeButton.tintColor = .white
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
    }
    
    @objc private func closeButtonHandler() {
        dismiss(animated: true)
    }
    
    @objc private func sliderValueChangedHandler(_ slider: UISlider) {
        processor.adjustValue = CGFloat(slider.value)
        sliderLabel.text = "\(slider.value)"
    }
}

// MARK: - CameraViewDelegate

extension ScanViewController: CameraViewDelegate {
    
    func cameraView(_ view: CameraView, didCapture image: UIImage) {
//        processor.process(image: image) { [weak self] result in
//            self?.previewImageView.image = result
//        }
        
    }
    
}
