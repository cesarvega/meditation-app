import SwiftUI
import Foundation
import AuthenticationServices
import CryptoKit
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
    
    // Apple Sign-In: Store nonce for security
    private var currentNonce: String?
    
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
    
    // MARK: - User Profile Management
    func updateUserName(_ newName: String) {
        guard var user = currentUser, !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Create updated user with new name
        let updatedUser = User(
            id: user.id,
            email: user.email,
            name: newName.trimmingCharacters(in: .whitespacesAndNewlines),
            profileImageURL: user.profileImageURL
        )
        
        self.currentUser = updatedUser
        saveUser(updatedUser)
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
        #if canImport(GoogleSignIn)
        GIDSignIn.sharedInstance.signOut()
        #endif
        
        currentUser = nil
        isAuthenticated = false
        clearStoredUser()
        errorMessage = nil
    }
    
    // MARK: - Sign in with Apple
    func signInWithApple() async {
        // This method is not needed with SignInWithAppleButton
        // The button handles the request automatically
        // We only need handleAppleSignInCompletion for processing results
    }
    
    // Handle Apple Sign-In completion
    func handleAppleSignInCompletion(_ authorization: ASAuthorization) async {
        isLoading = true
        errorMessage = nil
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            self.errorMessage = "Unable to get Apple ID credential"
            isLoading = false
            return
        }
        
        // Extract user information
        let userId = appleIDCredential.user
        
        // Apple may provide email on first sign-in, or use existing stored email
        let email = appleIDCredential.email ?? "apple_user_\(userId.prefix(8))@privaterelay.appleid.com"
        
        // Get name from credential or create friendly fallback
        var fullName = "Mindful User"
        if let givenName = appleIDCredential.fullName?.givenName {
            if let familyName = appleIDCredential.fullName?.familyName {
                fullName = "\(givenName) \(familyName)"
            } else {
                fullName = givenName
            }
        } else {
            // Create a more personalized fallback name
            let friendlyNames = [
                "Zen Master",
                "Peaceful Soul",
                "Mindful Explorer", 
                "Calm Spirit",
                "Meditation Friend",
                "Tranquil Mind",
                "Serene Being",
                "Harmony Seeker"
            ]
            fullName = friendlyNames.randomElement() ?? "Mindful User"
        }
        
        // Create user
        let user = User(
            id: userId,
            email: email,
            name: fullName
        )
        
        // Save user and authenticate
        self.currentUser = user
        self.isAuthenticated = true
        saveUser(user)
        
        isLoading = false
        print("✅ Apple Sign-In successful: \(user.name) (\(user.email))")
    }
    
    // MARK: - Apple Sign-In Utilities
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // MARK: - Utility Functions    // MARK: - Utility Functions
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
    case networkError
    case userNotFound
    case signInCanceled
    case signInFailed
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network connection failed"
        case .userNotFound:
            return "User not found"
        case .signInCanceled:
            return "Sign-in was canceled"
        case .signInFailed:
            return "Sign-in failed. Please try again."
        }
    }
}