//
//  MovementManager.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/28/24.
//
import SwiftUI
import Foundation
import CoreMotion

class MovementManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let updateInterval = 0.1
    //private var accelerometerHistory: [SensorData] = []
    //private var gyroscopeHistory: [SensorData] = []
    
    func startAccelerometerUpdates(completion: @escaping (SensorData) -> Void) {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let data = data, error == nil else { return }
            completion(SensorData(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z))
        }
    }
    
    func startGyroscopeUpdates(completion: @escaping (SensorData) -> Void) {
        guard motionManager.isGyroAvailable else { return }
        motionManager.gyroUpdateInterval = updateInterval
        motionManager.startGyroUpdates(to: .main) { data, error in
            guard let data = data, error == nil else { return }
            completion(SensorData(x: data.rotationRate.x, y: data.rotationRate.y, z: data.rotationRate.z))
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }
    
    func saveDataToJson(sensorData: [String: [[String: Double]]]) {
        // Create a file URL in the app's documents directory
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent("sensorData.json")
        
        // Encode the data into JSON format
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(sensorData)
            
            // Write the encoded data to the file
            try data.write(to: fileURL)
            print("Data saved successfully at \(fileURL.path)")
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    private func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
}
