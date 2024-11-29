//
//  ContentView.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/28/24.
//

import SwiftUI
import CoreBluetooth


import SwiftUI
import CoreBluetooth

struct ContentView: View {
    // MARK: -Bluetooth sensors
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack {
            Image(systemName: "figure.walk")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Movement App")
            
            if bluetoothManager.isBluetoothOn {
                Text("Bluetooth is ON")
            } else {
                Text("Bluetooth is OFF")
            }
            
            // Display the received data from the Movesense device
            if !bluetoothManager.receivedData.isEmpty {
                Text("Received Data: \(bluetoothManager.receivedData)")
                    .padding()
            } else {
                Text("No data received yet.")
                    .padding()
            }

            if let peripheral = bluetoothManager.discoveredPeripheral {
                Text("Discovered device: \(peripheral.name ?? "Unknown")")
            } else {
                Text("Scanning for devices...")
            }
        }
        .padding()
        .onAppear {
            bluetoothManager.updateBluetoothStateManually()
        }
        
    }

}


#Preview {
    ContentView()
        .environmentObject(BluetoothManager())
}
