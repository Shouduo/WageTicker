//
//  SettingsView.swift
//  WageTicker
//
//  Created by Shouduo on 2023/6/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("dailyIncome", store: sharedDefaults) private var dailyIncome: Double = SettingsConfig.defaultDailyIncome
    @AppStorage("currencyCode", store: sharedDefaults) private var currencyCode: String = SettingsConfig.defaultCurrencyCode
    @AppStorage("startHour", store: sharedDefaults) private var startHour: Int = SettingsConfig.defaultStartHour
    @AppStorage("startMinute", store: sharedDefaults) private var startMinute: Int = SettingsConfig.defaultStartMinute
    @AppStorage("endHour", store: sharedDefaults) private var endHour: Int = SettingsConfig.defaultEndHour
    @AppStorage("endMinute", store: sharedDefaults) private var endMinute: Int = SettingsConfig.defaultEndMinute
    @AppStorage("workdaysString", store: sharedDefaults) private var workdaysString: String = SettingsConfig.defaultWorkdays.map{ String($0.id) }.joined()
    @AppStorage("primaryColor", store: sharedDefaults) private var primaryColor: String = SettingsConfig.defaultPrimaryColor
    
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var workdaysSelected: [Weekday] = []
    @State private var color: Color = Color.white
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text(LocalizedStringKey("Amount"))) {
                    NumberInput(title: Text(LocalizedStringKey("Daily Income")), value: $dailyIncome)
                    TextInput(title: Text(LocalizedStringKey("Currency Code")), text: $currencyCode)
                        .onChange(of: currencyCode) { newValue in
                            if newValue.count > 1 {
                                currencyCode = String(newValue.prefix(1))
                            }
                        }
                }
                
                Section(header: Text(LocalizedStringKey("Work Period"))) {
                    TimePicker(title: LocalizedStringKey("Punch-in"), time: $startTime)
                        .onChange(of: startTime) { newValue in
                            let calendar = Calendar.current
                            let components = calendar.dateComponents([.hour, .minute], from: newValue)
                            startHour = components.hour ?? 0
                            startMinute = components.minute ?? 0
                        }
                    TimePicker(title: LocalizedStringKey("Punch-out"), time: $endTime)
                        .onChange(of: endTime) { newValue in
                            let calendar = Calendar.current
                            let components = calendar.dateComponents([.hour, .minute], from: newValue)
                            endHour = components.hour ?? 0
                            endMinute = components.minute ?? 0
                        }
                    MultiSelector<Text, Weekday>(
                        label: Text(LocalizedStringKey("Workdays")),
                        options: [
                            .sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday
                        ],
                        optionToString: { $0.displayName },
                        selected: $workdaysSelected
                    )
                    .onChange(of: workdaysSelected) { newValue in
                        workdaysString = array2string(array: newValue)
                    }
                }
                
                Section(header: Text(LocalizedStringKey("Other"))) {
                    ColorPicker(LocalizedStringKey("Color Theme"), selection: $color, supportsOpacity: false)
                        .onChange(of: color) { newValue in
                            if let hexValue = newValue.toHex() {
                                primaryColor = hexValue
                            }
                        }
                }
            }
            .onAppear {
                startTime = Calendar.current.date(bySettingHour: startHour, minute: startMinute, second: 0, of: Date())!
                endTime = Calendar.current.date(bySettingHour: endHour, minute: endMinute, second: 0, of: Date())!
                workdaysSelected = string2array(string: workdaysString)
                color = Color(hex: primaryColor)
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
