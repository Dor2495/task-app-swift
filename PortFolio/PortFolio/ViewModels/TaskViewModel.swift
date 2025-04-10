//
//  TaskViewModel.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 11/04/2025.
//

import Foundation

/// A view model that manages task-related operations and data.
///
/// This class handles fetching, adding, and deleting tasks from a remote API.
/// It maintains a collection of tasks and provides methods to interact with them.
@Observable
class TaskViewModel {
    
    /// The collection of all tasks managed by this view model.
    var allTasks: [TaskModel] = []

    /// The base URL for the tasks API.
    let api = "http://localhost:3000/api/tasks"
    
    /// Fetches tasks for a specific user from the remote API.
    ///
    /// - Parameter id: The user ID for which to fetch tasks.
    ///
    /// This method makes an asynchronous network request to retrieve tasks associated
    /// with the specified user ID. Upon successful completion, it updates the `allTasks`
    /// property with the fetched tasks.
    func fetchTasks(_ id: Int) async {
        do {
            guard let url = URL(string: "\(api)/user/\(id)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    let taskResponse = try JSONDecoder().decode(TaskResponse.self, from: data)
                    print("Received tasks: \(taskResponse.tasks.count)")
                    self.allTasks = taskResponse.tasks
                } else {
                    print("Error: Server returned status code \(httpResponse.statusCode)")
                }
            }
            
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    /// Adds a new task to the remote API.
    ///
    /// - Parameter task: The task model to be added.
    ///
    /// This method creates a new task on the server with the provided task details.
    /// It formats the current date to be compatible with MySQL and sends a POST request
    /// to the API.
    func addTask(_ task: TaskModel) async {
        do {
            guard let url = URL(string: "\(api)/") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // Format the date to be compatible with MySQL
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = Date()
            let formattedDate = dateFormatter.string(from: date)
            
            let body : [String: Any] = [
                "title": task.title,
                "description": task.description,
                "created_at": formattedDate,
                "is_completed": task.isCompleted,
                "userId": task.userId
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 201 {
                    print("Task added successfully!")
                } else {
                    print("Error: Server returned status code \(httpResponse.statusCode)")
                }
            }
            
            
        } catch {
            print("Error adding task: \(error)")
        }
    }
    
    /// Deletes a task from the remote API.
    ///
    /// - Parameter id: The ID of the task to be deleted.
    ///
    /// This method sends a DELETE request to the API to remove the task with the
    /// specified ID from the server.
    func deleteTask(_ id: Int) async {
        do {
            guard let url = URL(string: "\(api)/\(id)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {    
                print("Response status code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    print("Task deleted successfully!")
                } else {
                    print("Error: Server returned status code \(httpResponse.statusCode)")
                }
                }
            
        } catch {
            print("Error deleting task: \(error)")
        }
    }


}
