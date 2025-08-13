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
    
    @Guide(description: "The deadline for the task, represented as a date Sring like this 'dd MMMM, yyyy'.")
    var deadline: String
}
