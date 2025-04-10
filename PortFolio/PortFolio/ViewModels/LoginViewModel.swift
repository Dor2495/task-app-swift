import Foundation

@Observable
class LoginViewModel {
    var email = ""
    var password = ""
    var isLogin = false
    var currentUser: UserModel? = nil

    let api = "http://localhost:3000/api/auth"

    func login(_ user: UserModel) async {
        do {
            guard let url = URL(string: "\(api)/login") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // Include id in the request body as the server is expecting it
            let body: [String: Any] = [
                "id": 0,
                "email": user.email,
                "password": user.password
            ]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("status 200")
                
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                let user = loginResponse.user
                print("User email: \(user.email)")
                
                
                // Store user data for session management
                self.currentUser = user
                saveUserSession(user)
                isLogin = true
            } else {
                print("Login failed")
                isLogin = false
            }
        } catch {
            print("Error: \(error)")
            isLogin = false
        }
    }
    
    // Save user session to UserDefaults for persistence
    private func saveUserSession(_ user: UserModel) {
        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "loggedInUser")
        }
    }
    
    // Check if user is already logged in from previous session
    func checkExistingSession() {
        if let userData = UserDefaults.standard.data(forKey: "loggedInUser"),
           let user = try? JSONDecoder().decode(UserModel.self, from: userData) {
            self.currentUser = user
            self.isLogin = true
        }
    }
    
    // Logout user and clear session
    func logout() {
        self.currentUser = nil
        self.isLogin = false
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
    }
}
