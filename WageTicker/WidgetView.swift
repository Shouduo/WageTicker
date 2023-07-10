//
//  WidgetView.swift
//  WageTicker
//
//  Created by Shouduo on 2023/7/2.
//

import SwiftUI
import NumberTicker

struct WidgetView: View {
    let isWidget: Bool
    let isDayoff: Bool
    let currency: String
    let accumulate: Double
    let progress: Double
    let isWorking: Bool
    let countdown: String
    let color: Color
    
    var textColor: [Color] {
        return color.isLight
        ? [Color.black, Color.white]
        : [Color.white, Color.black]
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cardWidth: CGFloat = geometry.size.width
            let aspectRatio: CGFloat = cardWidth / 140
            let numberFontSize: CGFloat = 24 * aspectRatio * 8 / CGFloat((String(format: "%.2f", accumulate).count + currency.count))
            let fontModifier = Font.system(size: numberFontSize, weight: .bold, design: .rounded)
            
            VStack {
                VStack {
                    Spacer()
                    if isDayoff {
                        Text(LocalizedStringKey("Day-off"))
                            .font(Font.system(size: 24 * aspectRatio * 8 / 7, weight: .bold, design: .rounded))
                            .foregroundColor(textColor[0])
                    }
                    else if isWidget {
                        Text("\(currency)\(String(format: "%.2f", accumulate))")
                            .font(fontModifier)
                            .foregroundColor(textColor[0])
                    } else {
                        NumberTicker(number: accumulate,
                                     decimalPlaces: 2,
                                     prefix: currency,
                                     shouldAnimateToInitialNumber: false,
                                     font: fontModifier
                        )
                        .foregroundColor(textColor[0])
                    }
                    Spacer()
                    HStack {
                        HStack {
                            VStack {
                                Text(isDayoff
                                     ? LocalizedStringKey("Have fun")
                                     : isWorking
                                     ? LocalizedStringKey("End in:")
                                     : LocalizedStringKey("Start in:")
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14 * aspectRatio, design: .rounded).bold())
                                .foregroundColor(textColor[0])
                                Spacer()
                                    .frame(minHeight: 0)
                                Text(isDayoff
                                     ? "(≥▽≤)"
                                     : countdown)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 18 * aspectRatio, design: .rounded).bold())
                                    .foregroundColor(textColor[0])
                            }
                            Spacer()
                            ProgressRing(
                                progress: isDayoff ? 1 : progress,
                                color: color,
                                bgColor: textColor[0].opacity(0.2),
                                lineWidth: 10 * aspectRatio)
                            .frame(width: 32 * aspectRatio, height: 32 * aspectRatio)
                            .padding(4 * aspectRatio)
                        }
                        .padding(8 * aspectRatio)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 60 * aspectRatio)
                    .background(
                        RoundedRectangle(cornerRadius: 12 * aspectRatio)
                            .foregroundColor(textColor[0].opacity(0.2))
                    )
                    
                }
            }
            .padding(8 * aspectRatio)
            .background(color)
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static private let widthes: [CGFloat] = [140, 148, 155, 158, 170]
    static private let isMultiSizeView: Bool = true
    static private let accumulate: Double = 8000.0
    
    struct WidthID: Hashable { // 自定义标识符类型
        let value: CGFloat
    }
    
    static var previews: some View {
        ScrollView {
            VStack {
                if !isMultiSizeView {
                    VStack {
                        WidgetView(isWidget: false, isDayoff: false, currency: "$", accumulate: accumulate, progress: 0.6, isWorking: true, countdown: "23:10", color: .blue)
                    }
                    .frame(width: 140, height: 140)
                    .cornerRadius(20)
                    .clipped()
                    VStack {
                        WidgetView(isWidget: true, isDayoff: false, currency: "$", accumulate: accumulate, progress: 0.6, isWorking: true, countdown: "23:10", color: .blue)
                    }
                    .frame(width: 140, height: 140)
                    .cornerRadius(20)
                    .clipped()
                } else {
                    ForEach(widthes, id: \.self) { width in
                        VStack {
                            WidgetView(isWidget: false, isDayoff: false, currency: "$", accumulate: 80.0, progress: 0.6, isWorking: false, countdown: "00:00", color: .green)
                        }
                        .frame(width: width, height: width)
                        .cornerRadius(20)
                        .clipped()
                        .id(WidthID(value: width))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        
    }
}
