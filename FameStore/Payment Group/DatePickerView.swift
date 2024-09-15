//
//  DatePickerView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 15.09.2024.
//

import SwiftUI

struct DatePickerView: View {
    @State private var selectedMonth = 1
    @State private var selectedYear = 2024

    let months = Array(1...12)
    let years = Array(2024...2034)

    var body: some View {
            HStack {
                // Month Picker
                Picker("Month", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text(String(format: "%02d", month)).tag(month)
                        // Display month as 01, 02, etc.
                    }
                }
                .padding(.trailing, -20.0)
                .pickerStyle(MenuPickerStyle()) // MenuPickerStyle / SegmentedPickerStyle / WheelPickerStyle gibi secenekler var
                .frame(width: 60, height: 50)
                .clipped()
                
                Text("/")

                // Year Picker
                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .padding(.leading, -20.0)
                .pickerStyle(MenuPickerStyle())
                .frame(width: 85, height: 50)
                .clipped()
            }
        
    }
}

#Preview {
    DatePickerView()
}
