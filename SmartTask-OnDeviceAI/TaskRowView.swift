//
//  TaskRowView.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import SwiftUI

struct TaskRowView: View {
    @State var task: TaskModel
    @State private var showingEditTaskView = false

    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .font(.headline)
                if let deadline = task.deadline {
                    Text(deadline, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button {
                showingEditTaskView.toggle()
            } label: {
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $showingEditTaskView) {
                // EditTaskView would go here
                EditTaskView(task: $task)
            }
        }
    }
}


//
//  EditTaskView.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import SwiftUI

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
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $task.title)
                    TextEditor(text: $task.details)
                        .frame(height: 100)
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
            .navigationTitle(task.title.isEmpty ? "New Task" : "Edit Task")
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




struct AITemoTaskRowView: View {
    @Binding var task: TaskModel      
    @State private var showingEditTaskView = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .font(.headline)
                if let deadline = task.deadline {
                    Text(deadline, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button {
                showingEditTaskView.toggle()
            } label: {
                Image(systemName: "pencil")
            }
            .sheet(isPresented: $showingEditTaskView) {
                EditTaskView(task: $task)  // <- pass binding
            }
        }
    }
}

