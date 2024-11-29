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
    }
