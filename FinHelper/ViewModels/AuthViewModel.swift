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
            
            print("Kayıt isteği gönderiliyor...")
            let response: AuthResponse = try await networkManager.makeRequest(
                endpoint: "/api/auth/register",
                method: .post,
                body: jsonData
            )
            print("Kayıt başarılı!")
            
            self.currentUser = response.user
            self.isAuthenticated = true
            saveToken(response.token)
            
        } catch let error as NetworkError {
            print("Kayıt hatası: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        } catch {
            print("Beklenmeyen hata: \(error.localizedDescription)")
            self.errorMessage = "Beklenmeyen bir hata oluştu"
        }
        
        isLoading = false
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loginRequest = ["email": email, "password": password]
            let jsonData = try JSONEncoder().encode(loginRequest)
            
            print("Giriş isteği gönderiliyor...")
            let response: AuthResponse = try await networkManager.makeRequest(
                endpoint: "/api/auth/login",
                method: .post,
                body: jsonData
            )
            print("Giriş başarılı!")
            
            self.currentUser = response.user
            self.isAuthenticated = true
            saveToken(response.token)
            
        } catch let error as NetworkError {
            print("Giriş hatası: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        } catch {
            print("Beklenmeyen hata: \(error.localizedDescription)")
            self.errorMessage = "Beklenmeyen bir hata oluştu"
        }
        
        isLoading = false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        self.currentUser = nil
        self.isAuthenticated = false
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
} 