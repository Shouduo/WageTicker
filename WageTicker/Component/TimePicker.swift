//
//  TimePicker.swift
//  WageTicker
//
//  Created by Shouduo on 2023/6/30.
//

import SwiftUI

struct TimePicker: View {
    var title: LocalizedStringKey
    @Binding var time: Date
    
    var body: some View {
        DatePicker(title, selection: $time, displayedComponents: .hourAndMinute)
    }
}

struct TimePicker_Previews: PreviewProvider {
    @State static var selectedTime = Date()
    
    static var previews: some View {
        NavigationView {
            Form {
                Section(header: Text("TimePicker")) {
                    TimePicker(title: "Start Time", time: $selectedTime)
                }
            }
        }
    }
}
