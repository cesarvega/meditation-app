//
//  MeditationApp.swift
//  Meditation
//
//  Created by Cesar Vega on 9/23/25.
//

import SwiftUI
#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

@main
struct MeditationApp: App {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isAuthenticated {
                    ContentView()
                        .environmentObject(authManager)
                } else {
                    LoginView()
                        .environmentObject(authManager)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
            .onAppear {
                configureGoogleSignIn()
            }
            .onOpenURL { url in
                #if canImport(GoogleSignIn)
                GIDSignIn.sharedInstance.handle(url)
                #else
                // Handle URL for Google Sign-In when package is available
                print("Received URL: \(url)")
                #endif
            }
        }
    }
    
    private func configureGoogleSignIn() {
        // Configure Google Sign-In when GoogleService-Info.plist is available
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let clientId = plist["CLIENT_ID"] as? String else {
            print("Warning: GoogleService-Info.plist not found or CLIENT_ID missing")
            return
        }
        
        #if canImport(GoogleSignIn)
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
        print("Google Sign-In configured successfully")
        #else
        print("Google Sign-In configuration ready for when package is added")
        #endif
    }
}
