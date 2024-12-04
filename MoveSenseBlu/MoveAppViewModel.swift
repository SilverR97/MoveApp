//
//  MoveAppViewModel.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/29/24.
//

import Foundation

class MoveAppViewModel: ObservableObject {
    private let moveManager = MovementManager()
        private let mainModel = MainModel()  // Create an instance of MainModel
        
        @Published var accelerometerData: SensorData = SensorData(x: 0, y: 0, z: 0)
        @Published var gyroscopeData: SensorData = SensorData(x: 0, y: 0, z: 0)
        @Published var filteredAngles: AngleData = AngleData(pitch: 0.0, roll: 0.0)
        @Published var accelerometerHistory: [(String, Double)] = []
        @Published var gyroscopeHistory: [(String, Double)] = []
        @Published var angleHistory: [(Date, Double, Double)] = []
        @Published var isCollecting: Bool = false
        
        func startUpdates() {
            isCollecting = true
            moveManager.startAccelerometerUpdates { [weak self] data in
                DispatchQueue.main.async {
                    self?.accelerometerData = data
                    self?.updateHistory(for: &self!.accelerometerHistory, with: data)
                    self?.processAngles(from: data)  // Process angles with accelerometer data
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
                "Roll Angle": formatAngleHistory(angleHistory)
            ]
            
            // Save the data using the movement manager
            moveManager.saveDataToJson(sensorData: combinedData)
        }
        
        private func updateHistory(for history: inout [(String, Double)], with data: SensorData) {
            history.append(("X", data.x))
            history.append(("Y", data.y))
            history.append(("Z", data.z))
            if history.count > 300 {
                history.removeFirst(3)
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
    
    private func formatAngleHistory(_ history: [(Date, Double, Double)]) -> [[String: Double]] {
        var formattedData: [[String: Double]] = []
        for entry in history {
            // Each entry contains (Date, pitch, roll)
            let pitch = entry.1
            let roll = entry.2
            formattedData.append(["Pitch": pitch, "Roll": roll])
        }
        return formattedData
    }
    
        
        private func processAngles(from data: SensorData) {
            let angles = self.mainModel.processSensorData(data)  // Get the filtered angles
            self.filteredAngles = angles  // Update the filtered angles
            self.updateAngleHistory(with: angles)  // Update the history of angles
        }
        
        private func updateAngleHistory(with angles: AngleData) {
            // Store the filtered angles with timestamps for later analysis
            angleHistory.append((Date(), angles.pitch, angles.roll))
            if angleHistory.count > 300 {
                angleHistory.removeFirst()
            }
        }
    }
