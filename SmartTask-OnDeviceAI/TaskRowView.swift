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
                HStack {
                    Text(task.category.rawValue)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    if let deadline = task.deadline {
                        Text(deadline, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
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






struct AITemoTaskRowView: View {
    @Binding var task: TaskModel      
    @State private var showingEditTaskView = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .font(.headline)
                HStack {
                    Text(task.category.rawValue)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    if let deadline = task.deadline {
                        Text(deadline, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
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

