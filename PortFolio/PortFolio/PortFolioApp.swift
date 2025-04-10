//
//  PortFolioApp.swift
//  PortFolio
//
//  Created by Dor Mizrachi on 09/04/2025.
//

import SwiftUI

/// The main application struct for the Portfolio app.
///
/// This struct serves as the entry point for the application and configures
/// the initial environment with the login session.
@main
struct PortFolioApp: App {
    
    /// The login view model that manages the user's authentication state.
    private var session: LoginViewModel
    
    /// Initializes a new instance of the Portfolio app.
    ///
    /// This initializer creates a new login session to manage the user's
    /// authentication state throughout the application.
    init() {
        self.session = .init()
    }
    
    /// The body of the application.
    ///
    /// This property returns the main scene of the application, which consists
    /// of a window group containing the ContentView with the login session
    /// injected into the environment.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
        }
    }
}
