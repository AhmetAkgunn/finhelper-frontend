import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var username: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var birthDate: Date
    @State private var gender: User.Gender
    @State private var showingImagePicker = false
    @State private var showingPasswordChange = false
    @State private var showingSaveAlert = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        _name = State(initialValue: viewModel.currentUser.name)
        _username = State(initialValue: viewModel.currentUser.username ?? "")
        _email = State(initialValue: viewModel.currentUser.email)
        _phoneNumber = State(initialValue: viewModel.currentUser.phoneNumber ?? "")
        _birthDate = State(initialValue: viewModel.currentUser.birthDate ?? Date())
        _gender = State(initialValue: viewModel.currentUser.gender ?? .other)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Profil fotoğrafı
                Section {
                    HStack {
                        Spacer()
                        Button(action: { showingImagePicker = true }) {
                            if let profileImage = viewModel.currentUser.profileImage {
                                Image(systemName: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                } header: {
                    Text("Profil Fotoğrafı")
                }
                
                // Kişisel bilgiler
                Section(header: Text("Kişisel Bilgiler")) {
                    TextField("Ad Soyad", text: $name)
                    TextField("Kullanıcı Adı", text: $username)
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Telefon", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    
                    DatePicker("Doğum Tarihi", selection: $birthDate, displayedComponents: .date)
                    
                    Picker("Cinsiyet", selection: $gender) {
                        ForEach(User.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                }
                
                // Şifre değiştirme
                Section {
                    Button("Şifre Değiştir") {
                        showingPasswordChange = true
                    }
                }
            }
            .navigationTitle("Profili Düzenle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveChanges()
                    }
                }
            }
            .alert("Profil Güncellendi", isPresented: $showingSaveAlert) {
                Button("Tamam") {
                    dismiss()
                }
            } message: {
                Text("Profil bilgileriniz başarıyla güncellendi.")
            }
        }
    }
    
    private func saveChanges() {
        var updatedUser = viewModel.currentUser
        updatedUser.update(
            name: name,
            username: username,
            email: email,
            phoneNumber: phoneNumber,
            birthDate: birthDate,
            gender: gender
        )
        // ViewModel'de kullanıcı güncelleme işlemi yapılacak
        showingSaveAlert = true
    }
} 