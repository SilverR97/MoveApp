//
//  DeviceSensView.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/28/24.
//

import SwiftUI

struct DeviceSensView: View {
    @StateObject private var motionVM = MoveAppViewModel()
    @State private var timeLimit: TimeInterval = 10.0 // Default time limit
    var body: some View {
        
        Image(systemName: "iphone.circle.fill")
            .imageScale(.large)
            .foregroundStyle(.tint)
        Text("Device sensors measurements")
            .font(.title)
        VStack(alignment: .leading){
            Text("Accelerometer data")
                .font(.title2)
                .fontWeight(.bold)
            Text("X:\(motionVM.accelerometerData.x, specifier: "%.2f")")
            Text("Y: \(motionVM.accelerometerData.y, specifier: "%.2f")")
            Text("Z: \(motionVM.accelerometerData.z, specifier: "%.2f")")
            
            Spacer().frame(height: 20)
            
            Text("Gyroscope data")
                .font(.title2)
                .fontWeight(.bold)
            Text("X: \(motionVM.gyroscopeData.x, specifier: "%.2f")")
            Text("Y: \(motionVM.gyroscopeData.y, specifier: "%.2f")")
            Text("Z: \(motionVM.gyroscopeData.z, specifier: "%.2f")")
        }
        .padding()
        Spacer().frame(height: 20)
        // Charts for accelerometer and gyroscope
        
        HStack {
            VStack{
                Text("Accelerometer Chart")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LineChartView(data: motionVM.accelerometerHistory)
                            .frame(height: 200)
                            .padding()
            }
            
            VStack{
                Text("Gyroscope Chart")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LineChartView(data: motionVM.gyroscopeHistory)
                    .frame(height: 200)
                    .padding()
            }
        }
        
        
        Spacer().frame(height: 20)
        HStack {
            Button("Start") {
                motionVM.startUpdates()
            }
            .disabled(motionVM.isCollecting)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Stop") {
                motionVM.stopUpdates()
            }
            .disabled(!motionVM.isCollecting)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    DeviceSensView()
}
