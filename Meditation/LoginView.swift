import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignUpMode = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        Spacer()
                            .frame(height: 50)
                        
                        // App Logo and Title
                        VStack(spacing: 15) {
                            Image(systemName: "leaf.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Text("Meditation")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                            
                            Text(isSignUpMode ? "Join our mindful community" : "Welcome back to your practice")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Login Form
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.9))
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    TextField("Enter your email", text: $email)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .foregroundColor(.white)
                                        .autocapitalization(.none)
                                        .keyboardType(.emailAddress)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.9))
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    if showPassword {
                                        TextField("Enter your password", text: $password)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .foregroundColor(.white)
                                    } else {
                                        SecureField("Enter your password", text: $password)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .foregroundColor(.white)
                                    }
                                    
                                    Button(action: { showPassword.toggle() }) {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            
                            // Confirm Password Field (Sign Up only)
                            if isSignUpMode {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Confirm Password")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        if showConfirmPassword {
                                            TextField("Confirm your password", text: $confirmPassword)
                                                .textFieldStyle(PlainTextFieldStyle())
                                                .foregroundColor(.white)
                                        } else {
                                            SecureField("Confirm your password", text: $confirmPassword)
                                                .textFieldStyle(PlainTextFieldStyle())
                                                .foregroundColor(.white)
                                        }
                                        
                                        Button(action: { showConfirmPassword.toggle() }) {
                                            Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                            
                            // Error Message
                            if let errorMessage = authManager.errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red.opacity(0.9))
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Login/Sign Up Button
                            Button(action: performAuthentication) {
                                HStack {
                                    if authManager.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Image(systemName: isSignUpMode ? "person.badge.plus" : "arrow.right.circle.fill")
                                        Text(isSignUpMode ? "Create Account" : "Sign In")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                )
                            }
                            .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
                            
                            // OR Divider
                            HStack {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.white.opacity(0.3))
                                
                                Text("OR")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 10)
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.white.opacity(0.3))
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
                            
                            // Toggle Sign Up/Sign In
                            Button(action: { 
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isSignUpMode.toggle()
                                    // Clear form when switching
                                    email = ""
                                    password = ""
                                    confirmPassword = ""
                                    authManager.errorMessage = nil
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(isSignUpMode ? "Already have an account?" : "Don't have an account?")
                                        .foregroundColor(.white.opacity(0.8))
                                    Text(isSignUpMode ? "Sign In" : "Sign Up")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                .font(.subheadline)
                            }
                            .disabled(authManager.isLoading)
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                            .frame(height: 50)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func performAuthentication() {
        Task {
            if isSignUpMode {
                await authManager.signUpWithEmailPassword(
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword
                )
            } else {
                await authManager.signInWithEmailPassword(
                    email: email,
                    password: password
                )
            }
        }
    }
    
    private func signInWithGoogle() {
        Task {
            await authManager.signInWithGoogle()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
}