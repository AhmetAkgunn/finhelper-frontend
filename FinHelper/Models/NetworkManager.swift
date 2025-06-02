import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Geçersiz URL adresi"
        case .noData:
            return "Sunucudan veri alınamadı"
        case .decodingError:
            return "Sunucudan gelen veri işlenemedi"
        case .serverError(let message):
            if message.contains("Server error: 401") {
                return "E-posta veya şifre hatalı"
            } else if message.contains("Server error: 409") {
                return "Bu e-posta adresi zaten kullanımda"
            } else if message.contains("Server error: 404") {
                return "Kullanıcı bulunamadı"
            } else if message.contains("Server error: 500") {
                return "Sunucu hatası, lütfen daha sonra tekrar deneyin"
            }
            return "Sunucu hatası: \(message)"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://finhelper.onrender.com"
    
    private init() {}
    
    func makeRequest<T: Codable>(endpoint: String, method: String = "GET", body: Data? = nil) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("Geçersiz sunucu yanıtı")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Server error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
} 