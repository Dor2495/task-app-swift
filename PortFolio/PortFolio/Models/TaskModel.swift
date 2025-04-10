//
//  TaskResponse.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 10/04/2025.
//

import Foundation

/// A model representing a task in the application.
///
/// This struct conforms to `Codable` to enable encoding and decoding from JSON.
/// It contains all the properties of a task including its ID, user ID, title,
/// description, completion status, and creation timestamp.
struct TaskModel: Codable {
    /// The unique identifier for the task.
    var id: Int
    
    /// The ID of the user who owns this task.
    var userId: Int
    
    /// The title of the task.
    var title: String
    
    /// A detailed description of the task.
    var description: String
    
    /// Indicates whether the task has been completed.
    var isCompleted: Bool
    
    /// The timestamp when the task was created.
    var createdAt: String
    
    /// Creates a new task with the specified properties.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the task.
    ///   - userId: The ID of the user who owns this task.
    ///   - title: The title of the task.
    ///   - description: A detailed description of the task.
    ///   - isCompleted: Indicates whether the task has been completed.
    ///   - createdAt: The timestamp when the task was created.
    init(
        id: Int,
        userId: Int,
        title: String,
        description: String,
        isCompleted: Bool,
        createdAt: String
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
    
    /// Creates a new task by decoding from the provided decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if reading from the decoder fails.
    ///
    /// This initializer handles the conversion from Int to Bool for the `isCompleted`
    /// property, as the API may return it as an integer (0 or 1).
    init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        
        // Handle the conversion from Int to Bool for is_completed
        if let intValue = try? container.decode(Int.self, forKey: .isCompleted) {
            self.isCompleted = intValue != 0
        } else {
            self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        }
        
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
    
    /// The coding keys used for encoding and decoding.
    ///
    /// This enum maps the property names to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case description
        case isCompleted = "is_completed"
        case createdAt = "created_at"
    }
}

/// A response model for task-related API requests.
///
/// This struct represents the response from the server when fetching tasks.
/// It contains a message and an array of tasks.
struct TaskResponse: Codable {
    /// A message from the server about the request.
    var message: String
    
    /// An array of tasks returned by the server.
    var tasks: [TaskModel]
    
    /// The coding keys used for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case message
        case tasks = "tasks"
    }
}
