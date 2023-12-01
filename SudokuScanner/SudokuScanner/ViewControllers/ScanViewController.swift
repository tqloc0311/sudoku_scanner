//
//  ScanViewController.swift
//  SudokuScanner
//
//  Created by Loc Tran on 26/03/2023.
//

import Foundation
import UIKit
import AVFoundation
import SnapKit

class ScanViewController: UIViewController {
    
    // MARK: - Outlets
    
    private let closeButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let cameraView = CameraView(frame: .zero)
    private let previewImageView = UIImageView(frame: .zero)
    private let settingsView = SettingsView(frame: .zero)
    
    // MARK: - Properties
    lazy var processor: ImageProcessor = {
        return ImageProcessor()
    }()
    private var isProcessing = false
    private var isSettingsViewHidden = true {
        didSet {
            settingsView.isHidden = isSettingsViewHidden
        }
    }
    
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
        
        #if targetEnvironment(simulator)
        let label = UILabel(frame: .zero)
        view.addSubview(label)
        label.text = "Camera not available on simulator"
        label.textColor = .white
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        #else
        // add camera view
        view.addSubview(cameraView)
        cameraView.delegate = self
        cameraView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        #endif
        
        // preview image
        view.addSubview(previewImageView)
        previewImageView.clipsToBounds = true
        previewImageView.backgroundColor = .black
        previewImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(previewImageView.snp.width)
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
        
        // settings button
        view.addSubview(settingsButton)
        settingsButton.setImage(.init(systemName: "gear"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonHandler), for: .touchUpInside)
        settingsButton.tintColor = .white
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        // settings view
        view.addSubview(settingsView)
        settingsView.isHidden = true
        settingsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    @objc private func closeButtonHandler() {
        dismiss(animated: true)
    }
    
    @objc private func settingsButtonHandler() {
        isSettingsViewHidden.toggle()
    }
    
}

// MARK: - CameraViewDelegate

extension ScanViewController: CameraViewDelegate {
    
    func cameraView(_ view: CameraView, didCapture image: UIImage) {
        if isProcessing {
            return
        }
        
        isProcessing = true
        processor.process(image: image) { [weak self] result in
            self?.previewImageView.image = result
            self?.isProcessing = false
        }
    }
    
}
