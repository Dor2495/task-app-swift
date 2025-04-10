//
//  MainTabView.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 11/04/2025.
//

import SwiftUI

/// The main tab view of the application.
///
/// This view provides the primary navigation interface for the application,
/// displaying a tab bar with options to access the task list and user profile.
/// It is shown after the user has successfully logged in.
struct MainTabView: View {
    /// The login view model that manages the user's authentication state.
    @Environment(LoginViewModel.self) private var loginViewModel
    
    /// The body of the view.
    ///
    /// This property returns a tab view containing the task list and profile views.
    /// The task list is initialized with the current user's ID.
    var body: some View {
        TabView {
            
            TaskListView(userId: loginViewModel.currentUser?.id ?? 0)
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

/// A preview provider for the MainTabView.
///
/// This preview allows developers to see how the MainTabView looks in Xcode's
/// canvas without running the application.
#Preview {
    MainTabView()
}
