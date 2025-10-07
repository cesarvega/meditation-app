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

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let meditationId = userInfo["meditation_id"] as? String {
            NotificationCenter.default.post(name: .openMeditation, object: nil, userInfo: ["meditation_id": meditationId])
        }
        completionHandler()
    }
}

extension Notification.Name {
    static let openMeditation = Notification.Name("openMeditation")
}

@main
struct MeditationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .onAppear {
                configureGoogleSignIn()
                NotificationManager.shared.requestAuthorization()
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
