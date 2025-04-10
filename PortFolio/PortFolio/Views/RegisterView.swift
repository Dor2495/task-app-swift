//
//  RegisterView.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 09/04/2025.
//

import SwiftUI

/// A view that provides a registration interface for new users.
///
/// This view allows users to create a new account by entering their email and password.
/// It includes validation for the input fields and displays error messages if the registration fails.
/// Upon successful registration, it shows a success message and dismisses the view.
struct RegisterView: View {
    /// The environment variable for dismissing the view.
    @Environment(\.dismiss) private var dismiss
    
    /// The email entered by the user.
    @State private var email = ""
    
    /// The password entered by the user.
    @State private var password = ""
    
    /// The password confirmation entered by the user.
    @State private var confirmPassword = ""
    
    /// An optional error message to display to the user.
    @State private var errorMessage: String?
    
    /// A state variable that indicates whether the registration was successful.
    @State private var registrationSuccess = false
    
    /// The view model that manages the registration process.
    @State private var viewModel = RegisterViewModel()

    /// The body of the view.
    ///
    /// This property returns a navigation stack containing the registration form.
    /// The form includes text fields for the email, password, and password confirmation,
    /// a register button, and a cancel button.
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                Text("Create Account")
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
                        .textContentType(.newPassword)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .fontWeight(.medium)
                    
                    SecureField("Confirm your password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }
                
                Button {
                    register()
                } label: {
                    Text("Register")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Register")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Registration Successful", isPresented: $registrationSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your account has been created. Please log in.")
            }
        }
    }
    
    /// Attempts to register a new user with the provided credentials.
    ///
    /// This method validates the email, password, and password confirmation fields.
    /// If the validation passes, it attempts to register the user using the register view model.
    /// If the registration is successful, it shows a success message and dismisses the view.
    private func register() {
        // Basic validation
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        // Clear error message
        errorMessage = nil
        
        // Attempt registration
        Task {
            await viewModel.register(UserModel(email: email.lowercased(), password: password))
            
            // Show success message and dismiss
            await MainActor.run {
                registrationSuccess = true
            }
        }
    }
}

/// A preview provider for the RegisterView.
///
/// This preview allows developers to see how the RegisterView looks in Xcode's
/// canvas without running the application.
#Preview {
    RegisterView()
}
