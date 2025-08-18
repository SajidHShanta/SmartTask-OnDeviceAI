//
//  Task.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import Foundation
import FoundationModels

struct TaskModel: Identifiable, Codable {
    var id = UUID().uuidString
    var title: String
    var details: String
    var deadline: Date?
    var isCompleted: Bool = false
    var category: Category
}

@Generable
enum Category: String, CaseIterable, Codable {
    case meeting = "Meeting"
    case deskWork = "Desk Work"
    case visit = "Visit"
    case others = "Others"
}

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
    
    @Guide(description: "task category")
    var category: Category
}

//@Generable
//enum GeneratedCategory: String, CaseIterable, Codable {
////    @Guide(description: "Task category for meeting")
//    case meeting = "Meeting"
////    @Guide(description: "Task category for Desk Work")
//    case deskWork = "Desk Work"
////    @Guide(description: "Task category for")
//    case customerVisit = "Customer Visit"
////    @Guide(description: "Task category for Customer Visit")
//    case others = "Others"
//}
