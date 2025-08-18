//
//  ContentView.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var taskManager = TaskManager()
    @State private var showingAddTaskView = false
    @State private var showingAIPromptView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(taskManager.tasks) { task in
                    TaskRowView(task: task)
                }
                .onDelete(perform: taskManager.deleteTask)
            }
            .refreshable {
                
            }
            .navigationTitle("Activity Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAIPromptView.toggle()
                    } label: {
                        Label("AI Add Task", systemImage: "sparkles")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTaskView.toggle()
                    } label: {
                        Label("Add Task", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView(task: TaskModel(title: "", details: "", deadline: nil, category: .others)) { newTask in
                    taskManager.addTask(task: newTask)
                }
            }
            .sheet(isPresented: $showingAIPromptView) {
                AIPromptView() { newTasks in
                    for task in newTasks {
                        taskManager.addTask(task: task)
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
