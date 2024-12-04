//
//  GraphsView.swift
//  MoveSenseBlu
//
//  Created by Reinaldo Plata P on 11/29/24.
//

import SwiftUI
import Charts


struct LineChartView: View {
    var data: [(String, Double)] // Tuple of axis label and value
        var body: some View {
            Chart {
                ForEach(Array(data.enumerated()), id: \.offset) { index, entry in
                    LineMark(
                        x: .value("Index", index), // Use the index to represent the X-axis
                        y: .value("Value", entry.1) // Plot the value for the Y-axis
                    )
                    .foregroundStyle(by: .value("Axis", entry.0))
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
