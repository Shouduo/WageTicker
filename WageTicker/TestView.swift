//
//  TestView.swift
//  WageTicker
//
//  Created by Shouduo on 2023/6/30.
//

import SwiftUI
import Foundation

//struct Goal: Hashable, Identifiable {
//    var id: String { name }
//    var name: String
//}
//
//struct Task {
//    var name: String
//    var servingGoals: Set<Goal>
//}
//
//let allGoals: [Goal] = [Goal(name: "Learn Japanese"), Goal(name: "Learn SwiftUI"), Goal(name: "Learn Serverless with Swift")]
//
//struct TaskEditView: View {
//    @State var task = Task(name: "", servingGoals: [allGoals[1]])
//
//    var body: some View {
//        Form {
//            Section(header: Text("Name")) {
//                TextField("e.g. Find a good Japanese textbook", text: $task.name)
//            }
//
//            Section(header: Text("Relationships")) {
//                MultiSelector(
//                    label: Text("Serving Goals"),
//                    options: allGoals,
//                    optionToString: { $0.name },
//                    selected: $task.servingGoals
//                )
//            }
//        }.navigationTitle("Edit Task")
//    }
//}
//
//struct TaskEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            TaskEditView()
//        }
//    }
//}
