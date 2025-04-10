import Foundation

/// A model representing a user in the application.
///
/// This struct conforms to `Codable` to enable encoding and decoding from JSON.
/// It contains user information including ID, email, and password.
struct UserModel: Codable {
    /// The unique identifier for the user. Optional as it may not be available during registration.
    var id: Int?
    
    /// The email address of the user.
    var email: String
    
    /// The password or password hash of the user.
    var password: String
    
    /// Creates a new user with the specified email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    /// Creates a new user by decoding from the provided decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if reading from the decoder fails.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
    }
    
    /// The coding keys used for encoding and decoding.
    ///
    /// This enum maps the property names to their corresponding JSON keys.
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case password = "password_hash"
    }
}

/// A response model for login-related API requests.
///
/// This struct represents the response from the server when a user logs in.
/// It contains a message and the user information.
struct LoginResponse: Codable {
    /// A message from the server about the login attempt.
    var message: String
    
    /// The user information returned by the server upon successful login.
    var user: UserModel
    
    /// The coding keys used for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case message
        case user
    }
}
