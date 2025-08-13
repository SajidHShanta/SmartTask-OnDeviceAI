//
//  TaskManagerVM.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import SwiftUI
import Combine

class TaskManager: ObservableObject {
    @Published var tasks: [TaskModel] = []
    
    func addTask(task: TaskModel) {
        tasks.append(task)
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}
