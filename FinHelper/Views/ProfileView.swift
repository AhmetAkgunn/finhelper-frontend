import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ProfileView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showingSettings = false
    @State private var showingSupport = false
    @State private var showingProfileEdit = false
    @State private var navigateToLogin = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            List {
                // Profil başlığı
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.currentUser.name)
                                .font(.headline)
                            Text(viewModel.currentUser.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Profil ayarları
                Section {
                    Button(action: { showingProfileEdit = true }) {
                        Label("Profil Düzenle", systemImage: "pencil")
                    }
                    
                    Button(action: { showingSettings = true }) {
                        Label("Uygulama Ayarları", systemImage: "gear")
                    }
                }
                
                // Uygulama seçenekleri
                Section {
                    Button(action: { showingSupport = true }) {
                        Label("Destek Merkezi", systemImage: "questionmark.circle")
                    }
                }
                
                // Çıkış yap
                Section {
                    Button(action: { navigateToLogin = true }) {
                        Label("Çıkış Yap", systemImage: "arrow.right.square")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profil")
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingSupport) {
            SupportView()
        }
        .sheet(isPresented: $showingProfileEdit) {
            ProfileEditView(viewModel: viewModel)
        }
    }
}

// Ayarlar görünümü
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("notifications") private var notifications = true
    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("language") private var language = "Türkçe"
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            List {
                Toggle("Bildirimler", isOn: $notifications)
                Toggle("Koyu Mod", isOn: $darkMode)
                    .onChange(of: darkMode) { _, newValue in
                        updateAppearance(isDark: newValue)
                    }
                
                Picker("Dil", selection: $language) {
                    Text("Türkçe").tag("Türkçe")
                    Text("English").tag("English")
                }
            }
            .navigationTitle("Uygulama Ayarları")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Tamam") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
    
    private func updateAppearance(isDark: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        window.overrideUserInterfaceStyle = isDark ? .dark : .light
    }
}

// Destek merkezi görünümü
struct SupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var supportMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Lütfen Yaşadığınız Sorunu Açıklayınız")
                    .font(.headline)
                    .padding()
                
                TextEditor(text: $supportMessage)
                    .frame(height: 200)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                
                Button("Gönder") {
                    // Destek mesajını gönderme işlemi
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Destek Merkezi")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
        }
    }
} 