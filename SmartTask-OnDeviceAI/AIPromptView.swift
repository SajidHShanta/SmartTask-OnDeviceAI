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
    
    @State var isLoading: Bool = false
    
    @State private var session = LanguageModelSession()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TextEditor(text: $prompt)
                        .padding()
                        .frame(maxHeight: 100)
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
                        //                    if isLoading {
                        //                        ProgressView()
                        //                    } else {
                        //                        Text("Generate Tasks")
                        //                    }
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .disabled(isLoading || prompt.isEmpty)
                    
                    if !generatedTasks.isEmpty {
                        List {
                            ForEach($generatedTasks) { $task in
                                AITemoTaskRowView(task: $task)
                            }
                        }
                        Button("Confirm & Add to List") {
                            onSave(generatedTasks)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    
                    Spacer()
                }
                
                if isLoading { ProgressView() }
            }
            .navigationTitle("AI Task Generator")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func generateTasks() async {
        isLoading = true
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
            
            let formatter = ISO8601DateFormatter()
            //                  formatter.dateFormat = "dd MMMM, yyyy"
            
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
        isLoading = false
    }
}
