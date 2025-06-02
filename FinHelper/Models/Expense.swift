import Foundation

// Harcama kategorileri
enum ExpenseCategory: String, CaseIterable {
    case food = "Yemek"
    case transportation = "Ulaşım"
    case accommodation = "Konaklama"
    case health = "Sağlık"
    case other = "Diğer"
}

// Harcama modeli
struct Expense: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    let category: ExpenseCategory
    let paidBy: String
    let splitBetween: [String]
    
    // Kişi başı düşen miktar
    var amountPerPerson: Double {
        amount / Double(splitBetween.count)
    }
} 