import SwiftUI
import Foundation
#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

// MARK: - User Model
struct User: Codable {
    let id: String
    let email: String
    let name: String
    let profileImageURL: String?
    
    init(id: String, email: String, name: String, profileImageURL: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
    }
}

// MARK: - Authentication Manager
@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaultsKey = "meditation_app_user"
    
    init() {
        loadStoredUser()
    }
    
    // MARK: - Stored User Management
    private func loadStoredUser() {
        if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    private func saveUser(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userDefaultsKey)
        }
    }
    
    private func clearStoredUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    // MARK: - Email/Password Authentication
    func signInWithEmailPassword(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulate network delay and validation
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // Basic email validation
            guard isValidEmail(email) else {
                throw AuthenticationError.invalidEmail
            }
            
            guard password.count >= 6 else {
                throw AuthenticationError.passwordTooShort
            }
            
            // For demo purposes, we'll accept any valid email/password combination
            // In a real app, you'd integrate with Firebase Auth, AWS Cognito, etc.
            let user = User(
                id: UUID().uuidString,
                email: email,
                name: extractNameFromEmail(email)
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            saveUser(user)
            
        } catch {
            if let authError = error as? AuthenticationError {
                self.errorMessage = authError.localizedDescription
            } else {
                self.errorMessage = "Login failed. Please try again."
            }
        }
        
        isLoading = false
    }
    
    func signUpWithEmailPassword(email: String, password: String, confirmPassword: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulate network delay and validation
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            guard isValidEmail(email) else {
                throw AuthenticationError.invalidEmail
            }
            
            guard password.count >= 6 else {
                throw AuthenticationError.passwordTooShort
            }
            
            guard password == confirmPassword else {
                throw AuthenticationError.passwordsDoNotMatch
            }
            
            // Create new user
            let user = User(
                id: UUID().uuidString,
                email: email,
                name: extractNameFromEmail(email)
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            saveUser(user)
            
        } catch {
            if let authError = error as? AuthenticationError {
                self.errorMessage = authError.localizedDescription
            } else {
                self.errorMessage = "Sign up failed. Please try again."
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Google Sign-In
    @MainActor
    func signInWithGoogle() async {
        isLoading = true
        errorMessage = nil
        
        #if canImport(GoogleSignIn)
        // Real Google Sign-In implementation
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = windowScene.windows.first?.rootViewController else {
            self.errorMessage = "Unable to get root view controller"
            isLoading = false
            return
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            
            guard let profile = result.user.profile else {
                throw AuthenticationError.userNotFound
            }
            
            // Extract real user information from Google
            let user = User(
                id: result.user.userID ?? UUID().uuidString,
                email: profile.email,
                name: profile.name,
                profileImageURL: profile.imageURL(withDimension: 120)?.absoluteString
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            saveUser(user)
            
        } catch {
            if let gidError = error as? GIDSignInError {
                switch gidError.code {
                case .canceled:
                    self.errorMessage = "Sign-in was canceled"
                case .EMM:
                    self.errorMessage = "Enterprise Mobility Management error"
                case .keychain:
                    self.errorMessage = "Keychain error occurred"
                case .unknown:
                    self.errorMessage = "Unknown Google Sign-In error"
                @unknown default:
                    self.errorMessage = "Google Sign-In failed"
                }
            } else {
                self.errorMessage = "Google Sign-In failed. Please try again."
            }
            print("Google Sign-In error: \(error)")
        }
        #else
        // Fallback: Simulate Google Sign-In when package is not available
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            let user = User(
                id: UUID().uuidString,
                email: "demo@gmail.com",
                name: "Demo Google User",
                profileImageURL: nil // Will use SF Symbol for demo instead of external URL
            )
            
            self.currentUser = user
            self.isAuthenticated = true
            saveUser(user)
        } catch {
            self.errorMessage = "Google Sign-In simulation failed"
        }
        #endif
        
        isLoading = false
    }
    
    // MARK: - Google Sign-Out
    func signOutFromGoogle() {
        #if canImport(GoogleSignIn)
        GIDSignIn.sharedInstance.signOut()
        #endif
    }
    
    // MARK: - Sign Out
    func signOut() {
        // Sign out from Google if user was signed in with Google
        signOutFromGoogle()
        
        currentUser = nil
        isAuthenticated = false
        clearStoredUser()
        errorMessage = nil
    }
    
    // MARK: - Utility Functions
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func extractNameFromEmail(_ email: String) -> String {
        let parts = email.components(separatedBy: "@")
        if let username = parts.first {
            return username.capitalized
        }
        return "User"
    }
}

// MARK: - Authentication Errors
enum AuthenticationError: LocalizedError {
    case invalidEmail
    case passwordTooShort
    case passwordsDoNotMatch
    case networkError
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .passwordTooShort:
            return "Password must be at least 6 characters"
        case .passwordsDoNotMatch:
            return "Passwords do not match"
        case .networkError:
            return "Network connection failed"
        case .userNotFound:
            return "User not found"
        }
    }
}