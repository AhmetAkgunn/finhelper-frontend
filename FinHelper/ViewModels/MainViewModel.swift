import Foundation
import SwiftUI

// Ana uygulama verilerini yöneten ViewModel
class MainViewModel: ObservableObject {
    @Published var currentUser: User
    @Published var groups: [Group] = []
    @Published var selectedGroup: Group?
    
    init() {
        // Misafir kullanıcı ile başlatma
        self.currentUser = User.guestUser()
        
        // Örnek gruplar oluşturma
        let italyGroup = Group(
            name: "İtalya Gezisi",
            members: ["Sühan", "Furkan", "Ahmet", "Kürşat"],
            expenses: [],
            date: Date(),
            icon: "🇮🇹"
        )
        
        let homeGroup = Group(
            name: "Ev Arkadaşları",
            members: ["Sühan", "Furkan", "Ahmet"],
            expenses: [],
            date: Date(),
            icon: "🏠"
        )
        
        self.groups = [italyGroup, homeGroup]
    }
    
    // Yeni grup oluşturma
    func createGroup(name: String, members: [String], icon: String) {
        let newGroup = Group(name: name, members: members, expenses: [], date: Date(), icon: icon)
        groups.append(newGroup)
    }
    
    // Gruba harcama ekleme
    func addExpense(to group: Group, title: String, amount: Double, paidBy: String, splitBetween: [String], category: ExpenseCategory) {
        let expense = Expense(
            title: title,
            amount: amount,
            date: Date(),
            category: category,
            paidBy: paidBy,
            splitBetween: splitBetween
        )
        
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index].expenses.append(expense)
        }
    }
    
    // Grupları silme
    func deleteGroups(at offsets: IndexSet) {
        groups.remove(atOffsets: offsets)
    }
} 