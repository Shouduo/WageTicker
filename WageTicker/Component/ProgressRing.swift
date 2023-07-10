//
//  ProgressRing.swift
//  WageTicker
//
//  Created by Shouduo on 2023/6/29.
//

import SwiftUI

struct ProgressRing: View {
    
    var progress: CGFloat
    var color: Color = .red
    var bgColor: Color = .gray.opacity(0.2)
    var lineWidth: CGFloat = 30
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ZStack {
                Circle()
                    .stroke(bgColor, lineWidth: lineWidth)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                Circle()
                    .frame(width: lineWidth, height: lineWidth)
                    .offset(y: -geometry.size.height / 2)
                    .foregroundColor(color)
                    .shadow(color: Color.black.opacity(0.2),
                            radius: 0.05 * lineWidth, x: 0.15 * lineWidth)
                    .rotationEffect(
                        .degrees(360 * Double(progress)))
            }
            .frame(idealWidth: 300, idealHeight:300, alignment: .center)
        }
    }
}

struct ProgressRingView: View {
    @State private var progress: CGFloat = 0.75
    var body: some View {
        
        VStack {
            ZStack {
//                ProgressRing(progress: progress, color: .red)
//                    .frame(width: 238, height: 238)
//                ProgressRing(progress: progress, color: .green)
//                    .frame(width: 174, height: 174)
                ProgressRing(progress: progress, color: .blue)
                    .frame(width: 110, height: 110)
            }
            .padding()
            Text("\(progress)")
            Slider(value: $progress, in: 0...7, step: 0.01)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView()
    }
}
