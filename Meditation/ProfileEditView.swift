import SwiftUI

struct ProfileEditView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    @State private var newName: String = ""
    @State private var showingSaveSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Profile Header
                VStack(spacing: 15) {
                    // Profile Avatar
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 100, height: 100)
                        
                        Text(String(newName.prefix(1).uppercased()))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Edit Your Profile")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                // Name Editor
                VStack(alignment: .leading, spacing: 12) {
                    Text("Display Name")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your name", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                    
                    Text("This is how you'll appear in the app")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Current Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Email:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(authManager.currentUser?.email ?? "")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Text("Sign-in Method:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Apple ID")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save Button
                Button(action: saveProfile) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Changes")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Profile Updated!", isPresented: $showingSaveSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your display name has been updated successfully.")
            }
        }
        .onAppear {
            newName = authManager.currentUser?.name ?? ""
        }
    }
    
    private func saveProfile() {
        authManager.updateUserName(newName)
        showingSaveSuccess = true
    }
}

#Preview {
    ProfileEditView()
        .environmentObject(AuthenticationManager())
}