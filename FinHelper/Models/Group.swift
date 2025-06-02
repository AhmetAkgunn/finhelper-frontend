import Foundation

// Grup modelini tanımlayan yapı
struct Group: Identifiable {
    let id = UUID()
    var name: String
    var members: [String]
    var expenses: [Expense]
    var date: Date
    var icon: String
    
    // Gruptaki toplam harcama
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    // Kişi başı borç hesaplama
    func calculateDebts() -> [String: Double] {
        var debts: [String: Double] = [:]
        
        // Her üye için başlangıç borcu 0
        for member in members {
            debts[member] = 0
        }
        
        // Her harcama için borç hesaplama
        for expense in expenses {
            let amountPerPerson = expense.amountPerPerson
            
            // Ödeme yapan kişiye alacak ekleme
            debts[expense.paidBy, default: 0] += expense.amount
            
            // Harcamaya dahil olan kişilerden borç düşme
            for person in expense.splitBetween {
                debts[person, default: 0] -= amountPerPerson
            }
        }
        
        return debts
    }
} 