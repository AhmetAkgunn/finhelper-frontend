import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let networkManager = NetworkManager.shared
    
    func signUp(email: String, password: String, name: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let signUpRequest = SignUpRequest(email: email, password: password, name: name)
            let jsonData = try JSONEncoder().encode(signUpRequest)
            
            let response: AuthResponse = try await networkManager.makeRequest(
                endpoint: "/api/auth/signup",
                method: "POST",
                body: jsonData
            )
            
            self.currentUser = response.user
            self.isAuthenticated = true
            // Token'ı güvenli bir şekilde saklayın (Keychain'de)
            saveToken(response.token)
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loginRequest = ["email": email, "password": password]
            let jsonData = try JSONEncoder().encode(loginRequest)
            
            let response: AuthResponse = try await networkManager.makeRequest(
                endpoint: "/api/auth/login",
                method: "POST",
                body: jsonData
            )
            
            self.currentUser = response.user
            self.isAuthenticated = true
            saveToken(response.token)
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func saveToken(_ token: String) {
        // Token'ı Keychain'e kaydetme işlemi
        // Bu kısmı daha sonra implement edeceğiz
        UserDefaults.standard.set(token, forKey: "authToken")
    }
} 