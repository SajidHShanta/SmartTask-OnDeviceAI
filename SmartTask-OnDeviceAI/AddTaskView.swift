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
    @State var selectedCategory: Category?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $task.title)
                    TextEditor(text: $task.details)
                        .frame(height: 100)
                }
                
                Section(header: Text("Catergory")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.rawValue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == category ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        self.selectedCategory = category
                                        self.task.category = category
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
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
            .navigationTitle("New Activity")
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




struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    // Use a @Binding to modify the original task data directly.
    @Binding var task: TaskModel
    
    // A simple state variable to track if a deadline is enabled.
    // This provides a better user experience than checking `task.deadline != nil`.
    @State private var deadlineEnabled: Bool

    // An initializer to set the initial state of the deadline toggle.
    init(task: Binding<TaskModel>) {
        _task = task
        _deadlineEnabled = State(initialValue: task.deadline.wrappedValue != nil)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $task.title)
                    TextEditor(text: $task.details)
                        .frame(height: 100)
                }
                
                Section(header: Text("Catergory")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 12) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.rawValue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(task.category == category ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        self.task.category = category
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                
                Section(header: Text("Deadline")) {
                    // Use a toggle to manage the deadline date picker's visibility.
                    Toggle("Set a Deadline", isOn: $deadlineEnabled)
                        .tint(.blue)

                    if deadlineEnabled {
                        // The DatePicker selection is bound to the task's deadline
                        DatePicker(
                            "Date",
                            selection: Binding(
                                get: { task.deadline ?? Date() },
                                set: { newDate in task.deadline = newDate }
                            ),
                            displayedComponents: .date
                        )
                    }
                }
            }
            .navigationTitle("Edit Activity")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // If the deadline toggle is off, remove the deadline
                        if !deadlineEnabled {
                            task.deadline = nil
                        }
                        dismiss()
                    }
                    .disabled(task.title.isEmpty)
                }
            }
        }
    }
}
