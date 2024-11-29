//
//  BluetoothManager.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/28/24.
//

import Foundation
import CoreBluetooth
import Combine

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // Bluetooth properties
    //private var centralManager: CBCentralManager!
    
    private var sensorPeripheral: CBPeripheral?
    private var charData: CBCharacteristic?

    // Published properties for UI updates
    @Published var isBluetoothOn: Bool = false
    @Published var connectedDeviceName: String?
    @Published var receivedData: String = ""
    @Published var discoveredPeripheral: CBPeripheral?


    // Movesense UUIDs
    private let GATTService = CBUUID(string: "34802252-7185-4d5d-b431-630e7050e8f0")
    private let GATTCommand = CBUUID(string: "34800001-7185-4d5d-b431-630e7050e8f0")
    private let GATTData = CBUUID(string: "34800002-7185-4d5d-b431-630e7050e8f0")
    
    private var centralManager: CBCentralManager

    override init() {
        self.centralManager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        self.centralManager.delegate = self
    }
    
    func updateBluetoothStateManually() {
        centralManagerDidUpdateState(centralManager)
    }


    // MARK: - CBCentralManagerDelegate Methods

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            isBluetoothOn = true
            print("Bluetooth is powered on. Scanning for devices...")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff, .unauthorized, .unsupported:
            isBluetoothOn = false
            print("Bluetooth is unavailable.")
        default:
            print("Bluetooth state: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered device: \(peripheral.name ?? "Unknown") with RSSI: \(RSSI)")

        self.discoveredPeripheral = peripheral
        // Filter for the Movesense sensor by name and RSSI
        if let name = peripheral.name, name == "Movesense 180230000787" {
            print("Found Movesense sensor: \(name)")

            if RSSI.intValue > -70 { // Adjust RSSI threshold as needed
                print("Strong signal detected. Connecting to device...")

                sensorPeripheral = peripheral
                sensorPeripheral?.delegate = self
                centralManager.connect(sensorPeripheral!, options: nil)

                central.stopScan()
            } else {
                print("Signal too weak: RSSI = \(RSSI)")
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        connectedDeviceName = peripheral.name
        peripheral.delegate = self
        peripheral.discoverServices([GATTService])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown"): \(error?.localizedDescription ?? "No error info")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        connectedDeviceName = nil
    }

    // MARK: - CBPeripheralDelegate Methods

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        if let services = peripheral.services {
            for service in services {
                print("Discovered service: \(service.uuid)")
                if service.uuid == GATTService {
                    peripheral.discoverCharacteristics([GATTCommand, GATTData], for: service)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }

        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Discovered characteristic: \(characteristic.uuid)")
                if characteristic.uuid == GATTData {
                    charData = characteristic
                    print("Ready to communicate with \(characteristic.uuid)")
                    // Add further actions like reading or writing data
                    
                    peripheral.readValue(for: characteristic)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error updating value: \(error.localizedDescription)")
            return
        }

        if let data = characteristic.value {
            let stringData = String(decoding: data, as: UTF8.self)
            print("Received data from \(characteristic.uuid): \(stringData)")
             // Update the UI with received data
            
            DispatchQueue.main.async{
                self.receivedData = stringData
            }
        }
    }
}
