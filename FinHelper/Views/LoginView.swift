import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo
                Image("finhelper_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 30)
                
                // Başlık
                Text("FinHelper")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // Giriş formu
                VStack(spacing: 15) {
                    TextField("E-posta", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Şifre", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: login) {
                        if authViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Giriş Yap")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .disabled(!isFormValid || authViewModel.isLoading)
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 30)
                
                // Kayıt ol butonu
                Button(action: { showingSignUp = true }) {
                    Text("Hesabın yok mu? Kayıt ol")
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showingSignUp) {
            SignUpView()
        }
        .fullScreenCover(isPresented: .init(
            get: { authViewModel.isAuthenticated },
            set: { _ in }
        )) {
            ContentView()
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        email.contains("@") && 
        email.contains(".")
    }
    
    private func login() {
        Task {
            await authViewModel.login(email: email, password: password)
        }
    }
}

#Preview {
    LoginView()
}
