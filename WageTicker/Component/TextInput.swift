//
//  TextInput.swift
//  WageTicker
//
//  Created by Shouduo on 2023/7/1.
//

import SwiftUI

struct TextInput: View {
    var title: Text
    @Binding var text: String
    var placeholder: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                title
                Spacer()
                TextField(placeholder, text: $text)
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

struct TextInput_Previews: PreviewProvider {
    @State static var text: String = "hello world"
    
    static var previews: some View {
        NavigationView {
            Form {
                Section(header: Text("TextInput")) {
                    TextInput(title: Text("TextInput"), text: $text, placeholder: "input some text")
                }
            }
        }
    }
}
