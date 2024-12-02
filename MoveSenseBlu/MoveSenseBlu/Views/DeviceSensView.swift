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
            .resizable(resizingMode: .stretch)
            .foregroundStyle(.tint)
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .frame(width: 150.0, height: 150.0)
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
                Text("Algorithm 1 Chart")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LineChartView(data: motionVM.accelerometerHistory)
                    .frame(height: 300)
                    .padding()
            }
            
            VStack{
                Text("Algorithm 2 Chart")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LineChartView(data: motionVM.gyroscopeHistory)
                    .frame(height: 300)
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
        Spacer().frame(height: 10)
        
        // Save Data Button
        Button(action: {
            motionVM.saveData()
        }) {
            Text("Save Data")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        
    }
}

#Preview {
    DeviceSensView()
}
