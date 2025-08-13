//
//  AddTaskView.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @State var task: TaskModel
    var onSave: (TaskModel) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $task.title)
                    TextEditor(text: $task.details)
                        .frame(height: 100)
                }
                
                Section(header: Text("Deadline")) {
                    DatePicker("Deadline", selection: Binding(get: {
                        self.task.deadline ?? Date()
                    }, set: { newDate in
                        self.task.deadline = newDate
                    }), displayedComponents: .date)
                    
                    if task.deadline != nil {
                        Button("Remove Deadline") {
                            task.deadline = nil
                        }
                    }
                }
            }
            .navigationTitle(task.title.isEmpty ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(task)
                        dismiss()
                    }
                    .disabled(task.title.isEmpty)
                }
            }
        }
    }
}
