//
//  AIPromptView.swift
//  SmartTask-OnDeviceAI
//
//  Created by Sajid Shanta on 13/8/25.
//

import SwiftUI
import FoundationModels

struct AIPromptView: View {
    @Environment(\.dismiss) var dismiss
    @State private var prompt: String = ""
    @State private var generatedTasks: [TaskModel] = []
    var onSave: ([TaskModel]) -> Void
    
    @State private var session = LanguageModelSession()

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $prompt)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(.secondary, lineWidth: 1)
                    )
                    .padding()
                
                Button(action: {
                    Task {
                        await generateTasks()
                    }
                }, label: {
                    Text("Generate Tasks")
                })
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(prompt.isEmpty)
                
                if !generatedTasks.isEmpty {
                    List {
                        ForEach(generatedTasks.indices, id: \.self) { index in
                            TaskRowView(task: generatedTasks[index])
                        }
                    }
                    Button("Confirm & Add to List") {
                        // Add generatedTasks to your main task manager
                        onSave(generatedTasks)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("AI Task Generator")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func generateTasks() async {
        generatedTasks = []
        guard case .available = SystemLanguageModel.default.availability else {
                  // Handle cases where the model is not available
                  return
              }

              do {
                  // Stream the response, generating an array of `GeneratedTask`
                  let stream = session.streamResponse(to: prompt, generating: [GeneratedTask].self)
                  
                  var finalTasks: Array<GeneratedTask>.PartiallyGenerated = []
                  
                  for try await partialTasks in stream {
                      finalTasks = partialTasks
                  }
                  
                  let formatter = DateFormatter()
                  formatter.dateFormat = "dd MMMM, yyyy"
                  
                  for generatedTask in finalTasks {
                      if let title = generatedTask.title,
                         let details = generatedTask.details,
                         let deadline = generatedTask.deadline {
                          let newtask = TaskModel(title: title, details: details, deadline: formatter.date(from: deadline))
                          generatedTasks.append(newtask)
                      }
                  }
                  

              } catch {
                  // Handle any errors that occur during generation
                  print("Error generating tasks: \(error)")
              }
    }
}
//class vm {
//    func test() {
//        Task {
//            try await a()
//        }
//    }
//    
//    func a() async throws -> Void {
//        
//    }
//}
