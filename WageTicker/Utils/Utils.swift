//
//  Utils.swift
//  WageTicker
//
//  Created by Shouduo on 2023/7/2.
//

import SwiftUI
import Foundation

enum Weekday: Int, Identifiable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .sunday:
            return LocalizedStringKey("Sunday").stringValue()
        case .monday:
            return LocalizedStringKey("Monday").stringValue()
        case .tuesday:
            return LocalizedStringKey("Tuesday").stringValue()
        case .wednesday:
            return LocalizedStringKey("Wednesday").stringValue()
        case .thursday:
            return LocalizedStringKey("Thursday").stringValue()
        case .friday:
            return LocalizedStringKey("Friday").stringValue()
        case .saturday:
            return LocalizedStringKey("Saturday").stringValue()
        }
    }
}

extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
    
    func stringValue(locale: Locale = .current) -> String {
        let stringKey = self.stringKey!
        let localizedString = NSLocalizedString(stringKey, comment: "")
        return localizedString
    }

//    func stringValue(locale: Locale = .current) -> String? {
//        guard let stringKey = self.stringKey else { return nil }
//        let language = locale.languageCode
//        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else { return stringKey }
//        guard let bundle = Bundle(path: path) else { return stringKey }
//        let localizedString = NSLocalizedString(stringKey, bundle: bundle, comment: "")
//        return localizedString
//    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
    
    func toHex() -> String? {
        guard let components = self.cgColor?.components else { return nil }
        
        let red = Double(components[0])
        let green = Double(components[1])
        let blue = Double(components[2])
        
        let hex = String(format: "#%02lX%02lX%02lX", lround(red * 255), lround(green * 255), lround(blue * 255))
        
        return hex
    }
    
    var isLight: Bool {
        guard let components = cgColor?.components else { return false }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        
        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        
        return brightness > 0.5
    }
}

func array2string(array: [Weekday]) -> String {
    array.map{ String($0.id) }.joined()
}

func string2array(string: String) -> [Weekday] {
    string.compactMap { Weekday(rawValue: Int(String($0))!)}
}

func formatTime(timeInterval: TimeInterval) -> String {
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    let time = TimeInterval(timeInterval)
    guard let formattedString = formatter.string(from: time) else {
        return ""
    }
    return formattedString
}

func updateProgress(now: Date, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int, workdaysString: String) -> (Bool, Double, Bool, String) {
    let calendar = Calendar.current
    
    var startTime = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now)!
    var endTime = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: now)!
    
    var isOvernight: Bool
    
    if startHour > endHour {
        isOvernight = true
    } else if startHour < endHour {
        isOvernight = false
    } else {
        isOvernight = startMinute > endMinute
    }
    
    if isOvernight {
        if now > startTime {
            endTime = calendar.date(byAdding: .day, value: 1, to: endTime, wrappingComponents: false)!
        } else if now < endTime {
            startTime = calendar.date(byAdding: .day, value: -1, to: startTime, wrappingComponents: false)!
        }
    }
    
    let weekday = calendar.component(.weekday, from: startTime)
    
    var isDayoff: Bool = false
    var progress: Double = 0
    var isWorking: Bool = false
    var countdown: String = ""
    
    if workdaysString.contains(String(weekday)) {
        isDayoff = false
        if now > startTime && now < endTime {
            progress = (now.timeIntervalSince1970 - startTime.timeIntervalSince1970) / (endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970)
            isWorking = true
            let timeInterval = endTime.timeIntervalSince1970 - now.timeIntervalSince1970
            countdown = formatTime(timeInterval: timeInterval)
        } else {
            progress = 1
            isWorking = false
            var timeInterval = startTime.timeIntervalSince1970 - now.timeIntervalSince1970
            if timeInterval < 0 { timeInterval += 86400 }
            countdown = formatTime(timeInterval: timeInterval)
        }
    } else {
        isDayoff = true
    }
    return (isDayoff, progress, isWorking, countdown)
}

