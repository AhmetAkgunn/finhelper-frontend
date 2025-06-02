import Foundation

// Kullanıcı modelini tanımlayan yapı
struct User: Identifiable, Codable {
    let id: String // Backend'den gelen _id
    var name: String
    var email: String
    var password: String?
    var username: String?
    var profileImage: String?
    var phoneNumber: String?
    var birthDate: Date?
    var gender: Gender?
    
    // Cinsiyet enum'ı
    enum Gender: String, Codable, CaseIterable {
        case male = "Erkek"
        case female = "Kadın"
        case other = "Diğer"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case password
        case username
        case profileImage
        case phoneNumber
        case birthDate
        case gender
    }
    
    // Misafir kullanıcı oluşturmak için static fonksiyon
    static func guestUser() -> User {
        User(
            id: UUID().uuidString,
            name: "Suhan Dusunceli",
            email: "suhan@example.com",
            password: nil,
            username: "Suhan",
            profileImage: nil,
            phoneNumber: "+90 555 555 55 55",
            birthDate: nil,
            gender: .male
        )
    }
    
    // Demo kullanıcı
    static let demoUser = User(
        id: UUID().uuidString,
        name: "Demo User",
        email: "suhan@example.com",
        password: "suhan",
        username: "suhan",
        profileImage: nil,
        phoneNumber: "+90 555 555 55 55",
        birthDate: nil,
        gender: .male
    )
    
    // Kullanıcı doğrulama
    static func validateUser(username: String, password: String) -> Bool {
        return username.lowercased() == demoUser.username && 
               password == demoUser.password
    }
    
    // Kullanıcı bilgilerini güncelleme
    mutating func update(
        name: String? = nil,
        username: String? = nil,
        email: String? = nil,
        profileImage: String? = nil,
        password: String? = nil,
        phoneNumber: String? = nil,
        birthDate: Date? = nil,
        gender: Gender? = nil
    ) {
        if let name = name { self.name = name }
        if let username = username { self.username = username }
        if let email = email { self.email = email }
        if let profileImage = profileImage { self.profileImage = profileImage }
        if let password = password { self.password = password }
        if let phoneNumber = phoneNumber { self.phoneNumber = phoneNumber }
        if let birthDate = birthDate { self.birthDate = birthDate }
        if let gender = gender { self.gender = gender }
    }
}

// API Yanıt Modelleri
struct AuthResponse: Codable {
    let token: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case token
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        user = try container.decode(User.self, forKey: .user)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(user, forKey: .user)
    }
}

struct SignUpRequest: Codable {
    let email: String
    let password: String
    let name: String
} 
