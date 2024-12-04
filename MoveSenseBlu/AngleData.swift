//
//  AngleData.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 12/3/24.
//

import Foundation

struct AngleData {
    let pitch: Double
    let roll: Double
}

extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
