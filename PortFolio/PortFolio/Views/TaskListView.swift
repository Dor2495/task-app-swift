//
//  TaskListView.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 10/04/2025.
//

import SwiftUI

/// A view that displays a list of tasks for a specific user.
///
/// This view shows all tasks associated with a user in a list format.
/// Users can add new tasks, delete existing tasks, and view task details.
struct TaskListView: View {
    
    /// The ID of the user whose tasks are being displayed.
    var userId: Int
    
    /// The view model that manages the task data and operations.
    @State var viewModel = TaskViewModel()
    
    /// A state variable that controls the visibility of the add task sheet.
    @State private var showAddTaskView: Bool = false
    
    /// The body of the view.
    ///
    /// This property returns a navigation stack containing a list of tasks.
    /// Each task is displayed with its title and description.
    /// The view includes a toolbar with a button to add new tasks.
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.allTasks, id: \.id) { task in
                    VStack(alignment: .leading) {
                        Text(task.title)
                            .font(.headline)
                        Text(task.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteTask)
                   
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTaskView = true
                        
                    } label: {
                        Image(systemName: "plus.circle")
                    }

                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView(id: userId) { task in
                    Task {
                        await viewModel.addTask(task)
                        await viewModel.fetchTasks(userId)
                    }
                    showAddTaskView = false
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            Task {
                print("Fetching tasks for user ID: \(userId)")
                await viewModel.fetchTasks(userId)
                print("Tasks fetched: \(viewModel.allTasks.count)")
            }
        }
    }
    
    /// Deletes tasks at the specified indices.
    ///
    /// - Parameter offsets: The indices of the tasks to delete.
    ///
    /// This method is called when the user swipes to delete a task.
    /// It deletes the tasks from the server and refreshes the task list.
    private func deleteTask(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let id = viewModel.allTasks[index].id
                await viewModel.deleteTask(id)
                await viewModel.fetchTasks(userId)
            }
        }
    }
}

/// A preview provider for the TaskListView.
///
/// This preview allows developers to see how the TaskListView looks in Xcode's
/// canvas without running the application.
#Preview {
    TaskListView(userId: 1)
}
