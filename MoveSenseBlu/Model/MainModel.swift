//
//  MainModel.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 12/3/24.
//

import Foundation

class MainModel {
    private var pitchFilter = EMWAFilter(alpha: 0.1)
    private var rollFilter = EMWAFilter(alpha: 0.1)
    
    @Published var filteredPitch: Double = 0.0
    @Published var filteredRoll: Double = 0.0
    @Published var rawPitch: Double = 0.0
    @Published var rawRoll: Double = 0.0

    func processSensorData(_ data: SensorData) -> AngleData{
            let rawAngles = calculateAngles(from: data)
            let filteredPitch = pitchFilter.filter(newValue: rawAngles.pitch)
            let filteredRoll = rollFilter.filter(newValue: rawAngles.roll)
            
            // Update filtered values
                  DispatchQueue.main.async {
                      self.rawPitch = rawAngles.pitch
                      self.rawRoll = rawAngles.roll
                      self.filteredPitch = filteredPitch
                      self.filteredRoll = filteredRoll
                  }
        return AngleData(pitch: filteredPitch, roll: filteredRoll)
        }

    private func calculateAngles(from data: SensorData) -> AngleData {
        let pitch = atan2(data.y, sqrt(data.x * data.x + data.z * data.z)) * 180 / .pi
        let roll = atan2(-data.x, sqrt(data.y * data.y + data.z * data.z)) * 180 / .pi
        return AngleData(pitch: pitch, roll: roll)
    }
}
