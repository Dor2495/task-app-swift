import SwiftUI

/// A view that provides a login interface for users.
///
/// This view allows users to enter their email and password to log in to the application.
/// It includes validation for the input fields and displays error messages if the login fails.
/// It also provides a button to navigate to the registration view.
struct LoginView: View {
    /// The email entered by the user.
    @State private var email = ""
    
    /// The password entered by the user.
    @State private var password = ""
    
    /// A state variable that controls the visibility of the registration view.
    @State private var showRegisterView = false
    
    /// An optional error message to display to the user.
    @State private var errorMessage: String?
    
    /// The login view model that manages the user's authentication state.
    @Environment(LoginViewModel.self) private var viewModel
    
    /// The body of the view.
    ///
    /// This property returns a navigation stack containing the login form.
    /// The form includes text fields for the email and password, a login button,
    /// and a link to the registration view.
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                Text("Task Manager")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .fontWeight(.medium)
                    
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .fontWeight(.medium)
                    
                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.password)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }
                
                Button {
                    login()
                } label: {
                    Text("Login")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                HStack {
                    Text("Don't have an account?")
                    
                    Button {
                        showRegisterView = true
                    } label: {
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showRegisterView) {
                RegisterView()
            }
        }
    }
    
    /// Attempts to log in the user with the provided credentials.
    ///
    /// This method validates the email and password fields.
    /// If the validation passes, it attempts to log in the user using the login view model.
    /// If the login fails, it displays an error message.
    private func login() {
        // Basic validation
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        // Clear error message
        errorMessage = nil
        
        // Attempt login
        Task {
            await viewModel.login(UserModel(email: email.lowercased(), password: password))
            if !viewModel.isLogin {
                // Update error message on main thread
                await MainActor.run {
                    errorMessage = "Login failed. Please check your credentials."
                }
            }
        }
    }
}

/// A preview provider for the LoginView.
///
/// This preview allows developers to see how the LoginView looks in Xcode's
/// canvas without running the application.
#Preview {
    LoginView()
}
