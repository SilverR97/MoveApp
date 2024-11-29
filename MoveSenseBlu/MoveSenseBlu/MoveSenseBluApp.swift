//
//  MoveSenseBluApp.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/28/24.
//

import SwiftUI

@main
struct BluetoothApp: App {
    @StateObject private var bluetoothManager = BluetoothManager()

    var body: some Scene {
        WindowGroup {
            DeviceSensView()
               // .environmentObject(bluetoothManager) // Pass BluetoothManager to ContentView
        }
    }
}
