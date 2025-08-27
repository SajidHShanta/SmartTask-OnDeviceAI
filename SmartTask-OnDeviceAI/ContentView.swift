//
//  ContentView.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

/*
 demo promts:
 
 Create a task plan to organize a marketing roadshow
 
 Plan an onboarding checklist for a new iOS developer joining our team
 
 Create a plan to solve the canteen’s cockroach problem
 
 */

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject var taskManager = TaskManager()
    @State private var showingAddTaskView = false
    @State private var showingAIPromptView = false
    
    @State var  completionCount: Int = 0

    var body: some View {
        NavigationView {
            List {
                if !taskManager.tasks.isEmpty {
                    Section() {
                        onlineChart(online: completionCount, total: taskManager.tasks.count)
                            .listRowInsets(EdgeInsets()) // remove default insets
                            .listRowBackground(Color.clear)
                    }
                }

                ForEach(taskManager.tasks) { task in
                    TaskRowView(task: task) { taskStatusChange in
                        switch taskStatusChange {
                        case .incresed:
                            completionCount += 1
                        case .decresed:
                            if completionCount > 0 {
                                completionCount -= 1
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        if taskManager.tasks[index].isCompleted {
                            completionCount -= 1
                        }
                    }
                    taskManager.deleteTask(at: indexSet)
                })
            }
            .listStyle(.insetGrouped)
//            .listStyle(.plain)
            .navigationTitle("Activity List")
            .navigationBarTitleDisplayMode(.large)
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
    
    @ViewBuilder
    func onlineChart(online: Int, total: Int) -> some View {
        let data = [
            ("Done", Double(online)),
            ("Not Done Yet", Double(total - online))
        ]
        
        HStack(alignment: .center) {
            Spacer()
            Chart(data, id: \.0) { item in
                SectorMark(
                    angle: .value("Count", item.1),
                    innerRadius: .ratio(0.6),
                    angularInset: 1
                )
                .foregroundStyle(by: .value("Status", item.0))
            }
            .frame(width: 200, height: 200)
            .chartLegend(.visible)
            .chartLegend(alignment: .center)
            .overlay(
                Text("\(online)/\(total)")
                    .font(.title2.bold())
            )
            Spacer()
        }
    }

}

enum TaskStatusChange {
    case incresed
    case decresed
}


#Preview {
    ContentView()
}
