//
//  ProfileView.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 11/04/2025.
//

import SwiftUI

/// A view that displays the user's profile information.
///
/// This view shows the user's email and provides a button to log out.
/// It also includes a confirmation alert before logging out.
struct ProfileView: View {
    /// The login view model that manages the user's authentication state.
    @Environment(LoginViewModel.self) private var loginViewModel
    
    /// A state variable that controls the visibility of the logout confirmation alert.
    @State private var showingLogoutAlert = false
    
    /// The body of the view.
    ///
    /// This property returns a navigation stack containing the user's profile information.
    /// If the user is logged in, it displays their email and a logout button.
    /// If the user is not found, it displays a message indicating that.
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let user = loginViewModel.currentUser {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                        .padding()
                    
                    Text("Email: \(user.email)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        Text("Logout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                } else {
                    Text("User not found")
                        .font(.headline)
                }
            }
            .navigationTitle("Profile")
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    loginViewModel.logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
            .onAppear {
                loginViewModel.checkExistingSession()
            }
        }
    }
}

/// A preview provider for the ProfileView.
///
/// This preview allows developers to see how the ProfileView looks in Xcode's
/// canvas without running the application.
#Preview {
    ProfileView()
}
