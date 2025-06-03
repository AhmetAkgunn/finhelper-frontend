import Foundation

// Kullanıcı modelini tanımlayan yapı
struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var password: String?
    var username: String?
    var profileImage: String?
    var phoneNumber: String?
    var birthDate: Date?
    var gender: Gender?
    var createdAt: Date?
    var updatedAt: Date?
    
    // Cinsiyet enum'ı
    enum Gender: String, Codable, CaseIterable {
        case male = "Erkek"
        case female = "Kadın"
        case other = "Diğer"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case mongoId = "id" // Alternatif id alanı
        case name
        case email
        case password
        case username
        case profileImage
        case phoneNumber
        case birthDate
        case gender
        case createdAt
        case updatedAt
    }
    
    // Manuel initializer
    init(id: String, name: String, email: String, password: String? = nil, username: String? = nil, 
         profileImage: String? = nil, phoneNumber: String? = nil, birthDate: Date? = nil, gender: Gender? = nil,
         createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.username = username
        self.profileImage = profileImage
        self.phoneNumber = phoneNumber
        self.birthDate = birthDate
        self.gender = gender
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // Decoder initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // ID alanını farklı anahtarlardan dene
        if let _id = try? container.decode(String.self, forKey: .id) {
            id = _id
        } else if let mongoId = try? container.decode(String.self, forKey: .mongoId) {
            id = mongoId
        } else {
            // Eğer id bulunamazsa UUID oluştur
            id = UUID().uuidString
        }
        
        // Zorunlu alanlar
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        
        // Opsiyonel alanlar
        password = try container.decodeIfPresent(String.self, forKey: .password)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        birthDate = try container.decodeIfPresent(Date.self, forKey: .birthDate)
        gender = try container.decodeIfPresent(Gender.self, forKey: .gender)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }
    
    // Encoder function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // ID'yi _id olarak encode et
        try container.encode(id, forKey: .id)
        
        // Zorunlu alanlar
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        
        // Opsiyonel alanlar
        try container.encodeIfPresent(password, forKey: .password)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encodeIfPresent(profileImage, forKey: .profileImage)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(birthDate, forKey: .birthDate)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
    
    // Misafir kullanıcı oluşturmak için static fonksiyon
    static func guestUser() -> User {
        return User(
            id: UUID().uuidString,
            name: "Suhan Dusunceli",
            email: "suhan@example.com",
            username: "Suhan",
            phoneNumber: "+90 555 555 55 55",
            gender: .male
        )
    }
    
    // Demo kullanıcı
    static let demoUser = User(
        id: UUID().uuidString,
        name: "Demo User",
        email: "demo@example.com",
        password: "demo123",
        username: "demo",
        phoneNumber: "+90 555 555 55 55",
        gender: .male
    )
    
    // Kullanıcı doğrulama
    static func validateUser(username: String, password: String) -> Bool {
        return username.lowercased() == demoUser.username?.lowercased() && 
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
        
        do {
            user = try container.decode(User.self, forKey: .user)
        } catch {
            print("🚫 User Decoding Error: \(error)")
            throw error
        }
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
