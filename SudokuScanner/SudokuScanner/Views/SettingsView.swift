//
//  SettingsView.swift
//  SudokuScanner
//
//  Created by azibai loc on 29/11/2023.
//

import UIKit
import SnapKit

class SettingsView: UIView {
    
    // MARK: - Outlets
    
    private let minAdjustmentLabel = UILabel(frame: .zero)
    private let minAdjustmentSlider = UISlider(frame: .zero)
    private let epsilonLabel = UILabel(frame: .zero)
    private let epsilonSlider = UISlider(frame: .zero)
    private let thresholdLabel = UILabel(frame: .zero)
    private let thresholdSlider = UISlider(frame: .zero)
    
    // MARK: - Properties
    
    private var adjustment: Float = 0 {
        didSet {
            UserDefaults.standard.adjustment = adjustment
            minAdjustmentLabel.text = String(format: "Adjustment: %.2f", adjustment)
        }
    }
    
    private var epsilon: Float = 0 {
        didSet {
            UserDefaults.standard.epsilon = epsilon
            epsilonLabel.text = String(format: "Epsilon: %.4f", epsilon)
        }
    }
    
    private var threshold: Float = 0 {
        didSet {
            UserDefaults.standard.threshold = threshold
            thresholdLabel.text = String(format: "Threshold: %.2f", threshold)
        }
    }
    
    // MARK: - Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        let views = [
            minAdjustmentLabel,
            minAdjustmentSlider,
            epsilonLabel,
            epsilonSlider,
            thresholdLabel,
            thresholdSlider
        ]
        
        layoutSlider(minAdjustmentSlider,
                     minimumValue: Constants.minAdjustmentStart,
                     maximumValue: Constants.minAdjustmentEnd,
                     initialValue: UserDefaults.standard.adjustment)
        
        layoutSlider(epsilonSlider,
                     minimumValue: Constants.epsilonStart,
                     maximumValue: Constants.epsilonEnd,
                     initialValue: UserDefaults.standard.epsilon)
        
        layoutSlider(thresholdSlider,
                     minimumValue: Constants.thresholdStart,
                     maximumValue: Constants.thresholdEnd,
                     initialValue: UserDefaults.standard.threshold)
        
        layoutLabel(minAdjustmentLabel)
        layoutLabel(epsilonLabel)
        layoutLabel(thresholdLabel)
        
        let stackView = UIStackView(arrangedSubviews: views)
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        adjustment = UserDefaults.standard.adjustment
        epsilon = UserDefaults.standard.epsilon
        threshold = UserDefaults.standard.threshold
    }
    
    private func layoutLabel(_ label: UILabel) {
        label.textColor = .black
        label.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    private func layoutSlider(_ slider: UISlider, minimumValue: Float, maximumValue: Float, initialValue: Float) {
        slider.minimumValue = minimumValue
        slider.maximumValue = maximumValue
        slider.value = initialValue
        slider.addTarget(self, action: #selector(sliderValueChangedHandler(_:)), for: .valueChanged)
    }
    
    @objc private func sliderValueChangedHandler(_ slider: UISlider) {
        switch slider {
        case minAdjustmentSlider:
            let step = Constants.minAdjustmentStep
            let roundedValue = round(slider.value / step) * step
            slider.value = roundedValue
            adjustment = roundedValue
        case epsilonSlider:
            let step = Constants.epsilonStep
            let roundedValue = round(slider.value / step) * step
            slider.value = roundedValue
            epsilon = roundedValue
        case thresholdSlider:
            let step = Constants.thresholdStep
            let roundedValue = round(slider.value / step) * step
            slider.value = roundedValue
            threshold = roundedValue
        default: return
        }
    
    }
}

// MARK: - Constants

extension SettingsView {
    struct Constants {
        static let minAdjustmentStart: Float = 0
        static let minAdjustmentEnd: Float = 3
        static let minAdjustmentStep: Float = 0.05
        
        static let epsilonStart: Float = 0.0001
        static let epsilonEnd: Float = 0.01
        static let epsilonStep: Float = 0.0001
        
        static let thresholdStart: Float = 0.05
        static let thresholdEnd: Float = 0.95
        static let thresholdStep: Float = 0.025
    }
}
