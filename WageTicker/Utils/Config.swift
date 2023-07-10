//
//  Config.swift
//  WageTicker
//
//  Created by Shouduo on 2023/7/1.
//

import Foundation

let sharedDefaults = UserDefaults(suiteName: "group.com.shouduo.WageTicker")

enum SettingsConfig {
    static let defaultDailyIncome: Double = 8000.0
    static let defaultCurrencyCode: String = "$"
    static let defaultStartHour: Int = 10
    static let defaultStartMinute: Int = 0
    static let defaultEndHour: Int = 22
    static let defaultEndMinute: Int = 0
    static let defaultWeekdays: [Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    static let defaultWorkdays: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    static let defaultTimelinePeriod: Double = 120
    static let defaultTickInterval: Double = 5
    static let defaultPrimaryColor: String = "#85bb65"
}

