//
//  EMWA.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 12/3/24.
//

import Foundation

class EMWAFilter {
    private var alpha: Double
    private var currentValue: Double?
    
    init(alpha: Double) {
        self.alpha = alpha
    }
    
    func filter(newValue: Double) -> Double {
        if let value = currentValue {
            currentValue = alpha * newValue + (1 - alpha) * value
        } else {
            currentValue = newValue
        }
        return currentValue!
    }
}
