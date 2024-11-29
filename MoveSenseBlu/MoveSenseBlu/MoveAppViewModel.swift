//
//  MoveAppViewModel.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/29/24.
//

import Foundation

class MoveAppViewModel: ObservableObject {
    private let moveManager = MovementManager()
    
    @Published var accelerometerData: SensorData = SensorData(x: 0, y: 0, z: 0)
    @Published var gyroscopeData: SensorData = SensorData(x: 0, y: 0, z: 0)
    @Published var accelerometerHistory: [(String, Double)] = []
    @Published var gyroscopeHistory: [(String, Double)] = []
    @Published var isCollecting: Bool = false
    
    func startUpdates() {
        isCollecting = true
        moveManager.startAccelerometerUpdates { [weak self] data in
            DispatchQueue.main.async {
                self?.accelerometerData = data
                self?.updateHistory(for: &self!.accelerometerHistory, with: data)
            }
        }
        moveManager.startGyroscopeUpdates { [weak self] data in
            DispatchQueue.main.async {
                self?.gyroscopeData = data
                self?.updateHistory(for: &self!.gyroscopeHistory, with: data)
            }
        }
    }
    
    func stopUpdates() {
        moveManager.stopUpdates()
        isCollecting = false
    }
    
    func saveData() {
            // Combine all sensor histories into a dictionary
            let combinedData: [String: [[String: Double]]] = [
                "Accelerometer": formatHistory(accelerometerHistory),
                "Gyroscope": formatHistory(gyroscopeHistory),
                //"BluetoothSensor": bluetoothSensorHistory
            ]
            
            // Save the data using the movement manager
            moveManager.saveDataToJson(sensorData: combinedData)
        }
    
    private func updateHistory(for history: inout [(String, Double)], with data: SensorData) {
        // Append new data points for X, Y, Z axes
        history.append(("X", data.x))
        history.append(("Y", data.y))
        history.append(("Z", data.z))
        // Keep the most recent 100 points for simplicity
        if history.count > 300 { // 100 points per axis
            history.removeFirst(3) // Remove one complete set of X, Y, Z
        }
    }
    private func formatHistory(_ history: [(String, Double)]) -> [[String: Double]] {
            var formattedData: [[String: Double]] = []
            for i in stride(from: 0, to: history.count, by: 3) {
                guard i + 2 < history.count else { break }
                let x = history[i].1
                let y = history[i + 1].1
                let z = history[i + 2].1
                formattedData.append(["X": x, "Y": y, "Z": z])
            }
            return formattedData
        }
}
