//
//  Task.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import Foundation

struct TaskModel: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var details: String
    var deadline: Date?
    var isCompleted: Bool = false
}

import FoundationModels
// The model's blueprint for generating a single task
@Generable
struct GeneratedTask: Equatable, Codable {
    @Guide(description: "A concise title for the task.")
    var title: String
    
    @Guide(description: "Detailed information about the task.")
    var details: String
    
//    @Guide(description: "Task future deadline date as a string (e.g., 'dd MMMM, yyyy', '21 August, 2025'), always present or future.")
    @Guide(description: "Task deadline date as a string in ISO 8601 format (e.g., '2025-08-21T12:00:00Z'), always present or future.")
    var deadline: String
}
