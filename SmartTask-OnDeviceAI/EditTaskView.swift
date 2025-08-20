//
//  EditTaskView.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 20/8/25.
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

