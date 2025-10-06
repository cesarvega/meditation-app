import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.8),
                        Color.blue.opacity(0.6),
                        Color.indigo.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Background image overlay
                Image("BackgroundImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    // App Logo and Title
                    VStack(spacing: 20) {
                        Image(systemName: "leaf.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        VStack(spacing: 8) {
                            Text("Meditation")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                            
                            Text("Welcome to your mindful journey")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                    }
                    
                    // Social Authentication
                    VStack(spacing: 20) {
                        // Error Message
                        if let errorMessage = authManager.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red.opacity(0.9))
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.red.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        
                        // Google Sign-In Button
                        Button(action: signInWithGoogle) {
                            HStack(spacing: 12) {
                                // Google Icon
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 24, height: 24)
                                    
                                    Image(systemName: "globe")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.blue)
                                }
                                
                                if authManager.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(0.8)
                                    Text("Signing in...")
                                        .fontWeight(.medium)
                                } else {
                                    Text("Continue with Google")
                                        .fontWeight(.medium)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        .disabled(authManager.isLoading)
                        
                        // Sign in with Apple Button
                        SignInWithAppleButton(
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                handleAppleSignInResult(result)
                            }
                        )
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .disabled(authManager.isLoading)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Privacy Notice
                    VStack(spacing: 8) {
                        Text("By signing in, you agree to our")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        HStack(spacing: 4) {
                            Text("Terms of Service")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("and")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Privacy Policy")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func signInWithGoogle() {
        Task {
            await authManager.signInWithGoogle()
        }
    }
    
    private func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            Task {
                await authManager.handleAppleSignInCompletion(authorization)
            }
        case .failure(let error):
            // Handle user cancellation gracefully
            if let authError = error as? ASAuthorizationError {
                switch authError.code {
                case .canceled:
                    print("User canceled Apple Sign-In")
                    // Don't show error for user cancellation
                case .unknown:
                    authManager.errorMessage = "Apple Sign-In failed: Unknown error"
                case .invalidResponse:
                    authManager.errorMessage = "Apple Sign-In failed: Invalid response"
                case .notHandled:
                    authManager.errorMessage = "Apple Sign-In failed: Not handled"
                case .failed:
                    authManager.errorMessage = "Apple Sign-In failed: Authentication failed"
                case .notInteractive:
                    authManager.errorMessage = "Apple Sign-In failed: Not interactive"
                case .matchedExcludedCredential:
                    authManager.errorMessage = "Apple Sign-In failed: Matched excluded credential"
                case .credentialImport:
                    authManager.errorMessage = "Apple Sign-In failed: Credential import error"
                case .credentialExport:
                    authManager.errorMessage = "Apple Sign-In failed: Credential export error"
                @unknown default:
                    authManager.errorMessage = "Apple Sign-In failed: \(error.localizedDescription)"
                }
            } else {
                authManager.errorMessage = "Apple Sign-In failed: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
}