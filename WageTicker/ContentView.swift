//
//  ContentView.swift
//  WageTicker
//
//  Created by Shouduo on 2023/6/23.
//

import SwiftUI
import WidgetKit
import NumberTicker

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var timer: Timer?
    
    @State private var progress: Double = 0
    @State private var isWorking: Bool = false
    @State private var countdown: String = ""
    @State private var isDayoff: Bool = false
    
    @AppStorage("dailyIncome", store: sharedDefaults) private var dailyIncome: Double = SettingsConfig.defaultDailyIncome
    @AppStorage("currencyCode", store: sharedDefaults) private var currencyCode: String = SettingsConfig.defaultCurrencyCode
    @AppStorage("startHour", store: sharedDefaults) private var startHour: Int = SettingsConfig.defaultStartHour
    @AppStorage("startMinute", store: sharedDefaults) private var startMinute: Int = SettingsConfig.defaultStartMinute
    @AppStorage("endHour", store: sharedDefaults) private var endHour: Int = SettingsConfig.defaultEndHour
    @AppStorage("endMinute", store: sharedDefaults) private var endMinute: Int = SettingsConfig.defaultEndMinute
    @AppStorage("workdaysString", store: sharedDefaults) private var workdaysString: String = SettingsConfig.defaultWorkdays.map{ String($0.id) }.joined()
    @AppStorage("primaryColor", store: sharedDefaults) private var primaryColor: String = SettingsConfig.defaultPrimaryColor
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func update(now: Date) {
        (isDayoff, progress, isWorking, countdown) = updateProgress(now: now, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute, workdaysString: workdaysString)
    }
    
    private func startTimer() {
        update(now: Date())
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: SettingsConfig.defaultTickInterval, repeats: true) { _ in
            update(now: Date())
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                WidgetView(isWidget: false, isDayoff: isDayoff, currency: currencyCode, accumulate: dailyIncome * progress, progress: progress, isWorking: isWorking, countdown: countdown, color: Color(hex: primaryColor))
            }
            .frame(width: 160, height: 160)
            .cornerRadius(24)
            .clipped()
            .padding(12)
            .onAppear{ startTimer() }
            
            SettingsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color.gray)
        .edgesIgnoringSafeArea(.all)
//        .onTapGesture { hideKeyboard() }
        .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                WidgetCenter.shared.reloadTimelines(ofKind: "com.shouduo.WageTicker.WageWidget")
                break
            default:
                break
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .environment(\.locale, .init(identifier: "zh"))
    }
}
