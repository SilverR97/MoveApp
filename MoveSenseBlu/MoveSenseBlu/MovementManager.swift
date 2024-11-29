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
    }
