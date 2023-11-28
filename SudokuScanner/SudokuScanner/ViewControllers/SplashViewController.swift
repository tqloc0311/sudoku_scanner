//
//  SplashViewController.swift
//  SudokuScanner
//
//  Created by Loc Tran on 26/03/2023.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    private let scanButton = UIButton(type: .system)
    
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
        
        view.backgroundColor = .white
        
        view.addSubview(scanButton)
        scanButton.setTitle("Scan", for: .normal)
        scanButton.tintColor = .white
        scanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        scanButton.layer.cornerRadius = 50
        scanButton.backgroundColor = .systemBlue
        scanButton.addTarget(self,
                             action: #selector(scanButtonHandler),
                             for: .touchUpInside)
        scanButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        let previewImageView = UIImageView(frame: .zero)
        view.addSubview(previewImageView)
        previewImageView.layer.cornerRadius = 4
        previewImageView.layer.borderColor = UIColor.white.cgColor
        previewImageView.layer.borderWidth = 1
        previewImageView.clipsToBounds = true
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.snp.makeConstraints { make in
//            make.width.equalToSuperview().multipliedBy(1.0 / 3.0)
//            make.height.equalToSuperview().multipliedBy(1.0 / 3.0)
//            make.leading.equalToSuperview().offset(16)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.edges.equalToSuperview()
        }
        
        let image = UIImage(named: "sample1")!
        ImageProcessor().findContours(in: image)
//        previewImageView.image = demo
    }
    
    @objc private func scanButtonHandler() {
        let scanViewController = ScanViewController()
        scanViewController.modalPresentationStyle = .fullScreen
        present(scanViewController, animated: true)
    }
}
