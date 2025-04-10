//
//  ContentView.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 09/04/2025.
//

import SwiftUI

/// The main content view of the application.
///
/// This view serves as the root view of the application and manages the navigation
/// between the login screen and the main application interface based on the user's
/// authentication status.
///
/// When the app launches, it checks for an existing login session and displays
/// either the login screen or the main application interface accordingly.
struct ContentView: View {
    /// The login view model that manages authentication state.
    @Environment(LoginViewModel.self) private var loginViewModel
    
    /// The body of the view.
    ///
    /// This property returns a view that conditionally displays either the login screen
    /// or the main application interface based on the user's authentication status.
    var body: some View {
        Group {
            if loginViewModel.isLogin {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            // Check for existing login session
            loginViewModel.checkExistingSession()
        }
    }
}

/// A preview provider for the ContentView.
///
/// This preview allows developers to see how the ContentView looks in Xcode's
/// canvas without running the application.
#Preview {
    ContentView()
        .environment(LoginViewModel())
}
