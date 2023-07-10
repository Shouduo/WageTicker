//
//  WageWidget.swift
//  WageWidget
//
//  Created by Shouduo on 2023/6/26.
//

import WidgetKit
import SwiftUI
import Intents

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let isDayoff: Bool
    let dailyIncome: Double
    let currency: String
    let progress: Double
    let isWorking: Bool
    let countdown: String
    let color: Color
}

struct Provider: IntentTimelineProvider {
    
    @AppStorage("dailyIncome", store: sharedDefaults) var dailyIncome: Double = SettingsConfig.defaultDailyIncome
    @AppStorage("currencyCode", store: sharedDefaults) var currencyCode: String = SettingsConfig.defaultCurrencyCode
    @AppStorage("startHour", store: sharedDefaults) var startHour: Int = SettingsConfig.defaultStartHour
    @AppStorage("startMinute", store: sharedDefaults) var startMinute: Int = SettingsConfig.defaultStartMinute
    @AppStorage("endHour", store: sharedDefaults) var endHour: Int = SettingsConfig.defaultEndHour
    @AppStorage("endMinute", store: sharedDefaults) var endMinute: Int = SettingsConfig.defaultEndMinute
    @AppStorage("workdaysString", store: sharedDefaults) var workdaysString: String = SettingsConfig.defaultWorkdays.map{ String($0.id) }.joined()
    @AppStorage("primaryColor", store: sharedDefaults) var primaryColor: String = SettingsConfig.defaultPrimaryColor
    
    func placeholder(in context: Context) -> SimpleEntry {
        
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), isDayoff: false, dailyIncome: 8888, currency: "$", progress: 0.5, isWorking: true, countdown: "00:00", color: Color(hex: primaryColor))
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let (isDayoff, progress, isWorking, countdown) = updateProgress(now: Date(), startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, workdaysString: workdaysString)
        
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), isDayoff: isDayoff, dailyIncome: dailyIncome, currency: currencyCode, progress: progress, isWorking: isWorking, countdown: countdown, color: Color(hex: primaryColor))
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
 
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let entryCount = Int(SettingsConfig.defaultTimelinePeriod / SettingsConfig.defaultTickInterval)
        for i in 0 ..< entryCount {
            let entryDate = Calendar.current.date(byAdding: .second, value: i * Int(SettingsConfig.defaultTickInterval), to: currentDate)!
            let (isDayoff, progress, isWorking, countdown) = updateProgress(now: entryDate, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, workdaysString: workdaysString)
            
            let entry = SimpleEntry(date: entryDate, configuration: configuration, isDayoff: isDayoff, dailyIncome: dailyIncome, currency: currencyCode, progress: progress, isWorking: isWorking, countdown: countdown, color: Color(hex: primaryColor))
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}

struct WageWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        WidgetView(isWidget: true, isDayoff: entry.isDayoff, currency: entry.currency, accumulate: entry.dailyIncome * entry.progress, progress: entry.progress, isWorking: entry.isWorking, countdown: entry.countdown, color: entry.color)
    }
}

@main
struct WageWidget: Widget {
    let kind: String = "com.shouduo.WageTicker.WageWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(LocalizedStringKey("WidgetDisplayName"))
        .description(LocalizedStringKey("WidgetDescription"))
        .supportedFamilies([.systemSmall])
    }
}

struct WageWidget_Previews: PreviewProvider {
    static var previews: some View {
        WageWidgetEntryView(
            entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), isDayoff: false, dailyIncome: 8000, currency: "$", progress: 0.6, isWorking: true, countdown: "12:34", color: Color(hex: SettingsConfig.defaultPrimaryColor))
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

