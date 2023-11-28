//
//  DispatchQueue+Extensions.swift
//  SudokuScanner
//
//  Created by azibai loc on 28/11/2023.
//

import Foundation

extension DispatchQueue {

    static func executeOnBackground<T>(_ onBackground: (() -> T)?, completionOnMain: ((T?) -> Void)?) {
        DispatchQueue.global().async {
            
            let result = onBackground?()
            
            DispatchQueue.main.async {
                completionOnMain?(result)
            }
        }
    }
    
}
