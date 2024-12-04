//
//  GraphsView.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/29/24.
//

import SwiftUI
import Charts

struct AngleChartView: View {
    var pitchData: [(Date, Double)] // Array of tuples (timestamp, pitch value)
    
    var body: some View {
        Chart {
            // Pitch Data
            ForEach(Array(pitchData.enumerated()), id: \.offset) { index, entry in
                LineMark(
                    x: .value("Time", entry.0), // Use the timestamp for the X-axis
                    y: .value("Pitch", entry.1) // Use the pitch value for the Y-axis
                )
                .foregroundStyle(Color.blue) // Use blue for pitch line
                .annotation(position: .top) {
                    Text("Pitch") // Label the pitch line
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .padding()
    }
}
