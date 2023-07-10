//
//  NumberInput.swift
//  WageTicker
//
//  Created by Shouduo on 2023/7/1.
//

import SwiftUI

struct NumberInput: View {
    var title: Text
    @Binding var value: Double
    var placeholder: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                title
                Spacer()
                TextField(placeholder, value: $value, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .frame(maxWidth: geometry.size.width / 3)
            }
            .frame(height: 36)
        }
    }
}

struct NumberInput_Previews: PreviewProvider {
    @State static var value: Double = 8000.0
    
    static var previews: some View {
        NavigationView {
            Form {
                Section(header: Text("TextInput")) {
                    NumberInput(title: Text("TextInput"), value: $value)
                }
            }
        }
    }
}
