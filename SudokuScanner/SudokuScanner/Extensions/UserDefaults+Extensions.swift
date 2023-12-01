//
//  UserDefaults+Extensions.swift
//  SudokuScanner
//
//  Created by azibai loc on 29/11/2023.
//

import CoreGraphics
import Foundation

extension UserDefaults {
  
  var adjustment: Float {
    get {
      if let adjust = object(forKey: Settings.adjustment.rawValue) as? Float {
        return adjust
      }
      return 2.0
    }
    set {
      set(newValue, forKey: Settings.adjustment.rawValue)
    }
  }

  var epsilon: Float {
    get {
      if let epsilon = object(forKey: Settings.epsilon.rawValue) as? Float {
        return epsilon
      }
      return 0.001
    }
    set {
      set(newValue, forKey: Settings.epsilon.rawValue)
    }
  }

  var threshold: Float {
    get {
      if let thresh = object(forKey: Settings.threshold.rawValue) as? Float {
        return thresh
      }
      return 0.85
    }
    set {
      set(newValue, forKey: Settings.threshold.rawValue)
    }
  }

  func delete(key: Settings) {
    removeObject(forKey: key.rawValue)
  }
}
