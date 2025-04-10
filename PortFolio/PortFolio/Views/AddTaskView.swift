//
//  AddTaskView.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 10/04/2025.
//

import SwiftUI

/// A view for adding a new task.
///
/// This view provides a form interface for users to create a new task.
/// It includes fields for the task title, description, and completion status.
struct AddTaskView: View {
    /// The environment variable for dismissing the view.
    @Environment(\.dismiss) private var dismiss
    
    /// The ID of the user creating the task.
    var id: Int
    
    /// A closure that is called when the task is saved.
    ///
    /// This closure receives the newly created task model as its parameter.
    var onSave: ((TaskModel) -> Void)?
    
    /// Creates a new AddTaskView.
    ///
    /// - Parameters:
    ///   - id: The ID of the user creating the task.
    ///   - onSave: A closure that is called when the task is saved.
    init(id: Int, onSave: ((TaskModel) -> Void)? = nil) {
        self.id = id
        self.onSave = onSave
    }
    
    /// The title of the task.
    @State private var title: String = ""
    
    /// The description of the task.
    @State private var description: String = ""
    
    /// Whether the task is completed.
    @State private var isComplated: Bool = false
    
    /// The creation date of the task.
    @State private var createdAt: Date = Date.now
    
    /// The body of the view.
    ///
    /// This property returns a navigation stack containing a form for creating a new task.
    /// The form includes text fields for the title and description, and a toggle for the completion status.
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                Toggle("Completed", isOn: $isComplated)
                
                
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let stringDateFormatter = DateFormatter()
                        stringDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let newTaskModel = TaskModel(id: 0, userId: id, title: title, description: description, isCompleted: isComplated, createdAt: stringDateFormatter.string(from: createdAt))
                        
                        onSave?(newTaskModel)
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

/// A preview provider for the AddTaskView.
///
/// This preview allows developers to see how the AddTaskView looks in Xcode's
/// canvas without running the application.
#Preview {
    AddTaskView(id: 1)
}
