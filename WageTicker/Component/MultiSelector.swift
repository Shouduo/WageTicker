//
//  MultiSelector.swift
//  WageTicker
//
//  Created by Shouduo on 2023/6/30.
//

import SwiftUI

struct MultiSelectionView<Selectable: Identifiable & Hashable>: View {
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    
    @Binding var selected: [Selectable]
    
    @Environment(\.colorScheme) var colorScheme
    
    var textColor: Color {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.black
        }
    }
    
    private func toggleSelection(selectable: Selectable) {
        if let existingIndex = selected.firstIndex(where: { $0.id == selectable.id }) {
            selected.remove(at: existingIndex)
        } else {
            if let optionIndex = options.firstIndex(where: { $0.id == selectable.id }) {
                var insertionIndex = 0
                for (index, element) in selected.enumerated() {
                    if let elementIndex = options.firstIndex(where: { $0.id == element.id }),
                       elementIndex < optionIndex {
                        insertionIndex = index + 1
                    }
                }
                selected.insert(selectable, at: insertionIndex)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(optionToString(selectable))
                            .foregroundColor(textColor)
                        Spacer()
                        if selected.contains(where: { $0.id == selectable.id }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .tag(selectable.id)
            }
        }
        .listStyle(.insetGrouped)
//        .edgesIgnoringSafeArea([.top, .bottom])
//        .padding(.top, 24)
//        .navigationBarBackButtonHidden(true)
    }
}

struct MultiSelector<LabelView: View, Selectable: Identifiable & Hashable>: View {
    let label: LabelView
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    
    var selected: Binding<[Selectable]>
    
    private var formattedSelectedListString: String {
        let selectedOptions = selected.wrappedValue.map { optionToString($0) }
        return selectedOptions.joined(separator: ", ")
    }
    
    private func multiSelectionView() -> some View {
        MultiSelectionView(
            options: options,
            optionToString: optionToString,
            selected: selected
        )
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: multiSelectionView()) {
                HStack {
                    label
                    Spacer()
                    Text(formattedSelectedListString)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
}

struct PreviewView: View {
    @State var selected: [Weekday] = [.monday, .wednesday]
    
    var body: some View {
        NavigationView {
            Form {
                MultiSelector<Text, Weekday>(
                    label: Text("Multiselect"),
                    options: [
                        .sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday
                    ],
                    optionToString: { $0.displayName },
                    selected: $selected
                )
            }.navigationTitle("Title")
        }
    }
}

struct MultiSelector_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
}
