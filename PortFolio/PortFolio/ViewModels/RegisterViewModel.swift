import Foundation

@Observable
class RegisterViewModel {
    var email = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false
    var isRegistered = false

    let api = "http://localhost:3000/api/auth"

    func register(_ user: UserModel) async {
        isLoading = true
        
        do {
            let url = URL(string: "\(api)/register")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body : [String: Any] = ["id": 0, "email": user.email, "password": user.password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                await MainActor.run {
                    errorMessage = "Invalid response from server"
                    isLoading = false
                }
                return
            }
            
            if httpResponse.statusCode == 201 {
                // Successfully registered
                await MainActor.run {
                    isRegistered = true
                    isLoading = false
                }
            } else {
                // Try to decode error message
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let message = errorResponse["message"] {
                    await MainActor.run {
                        errorMessage = message
                        isLoading = false
                    }
                } else {
                    await MainActor.run {
                        errorMessage = "Registration failed with status code \(httpResponse.statusCode)"
                        isLoading = false
                    }
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
} 
