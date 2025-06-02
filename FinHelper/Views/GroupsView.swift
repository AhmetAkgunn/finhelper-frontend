import SwiftUI
import UIKit

struct GroupsView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showingCreateGroup = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.groups) { group in
                    NavigationLink(destination: GroupDetailView(group: group, viewModel: viewModel)) {
                        GroupRow(group: group)
                    }
                }
                .onDelete { indexSet in
                    deleteGroups(at: indexSet)
                }
            }
            .navigationTitle("Gruplar")
            .toolbar {
                Button(action: { showingCreateGroup = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateGroup) {
            CreateGroupView(viewModel: viewModel)
        }
    }
    
    private func deleteGroups(at offsets: IndexSet) {
        viewModel.deleteGroups(at: offsets)
    }
}

// Grup satırı bileşeni
struct GroupRow: View {
    let group: Group
    
    var body: some View {
        HStack {
            Text(group.icon)
                .font(.title)
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.headline)
                Text("\(group.members.count) Kişi")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// Grup detay görünümü
struct GroupDetailView: View {
    let group: Group
    @ObservedObject var viewModel: MainViewModel
    @State private var showingAddExpense = false
    @State private var selectedTab = 0 // 0: Harcamalar, 1: Bakiyeler
    @State private var showingDebtDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Grup başlığı
            HStack {
                Text(group.icon)
                    .font(.title)
                Text(group.name)
                    .font(.title2)
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            
            // Sekmeler
            HStack(spacing: 0) {
                TabButton(title: "Harcamalar", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabButton(title: "Bakiyeler", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
            }
            .padding(.horizontal)
            
            if selectedTab == 0 {
                // Harcamalar Görünümü
                VStack(spacing: 0) {
                    // Özet kartları
                    HStack(spacing: 15) {
                        SummaryCard(title: "Harcamlarım", amount: calculateMyExpenses())
                        SummaryCard(title: "Toplam Harcananlar", amount: group.totalExpenses)
                    }
                    .padding()
                    
                    // Harcama listesi
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(groupExpensesByDate(), id: \.0) { date, expenses in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(formatDate(date))
                                        .font(.headline)
                                        .padding(.horizontal)
                                        .padding(.top, 16)
                                    
                                    ForEach(expenses) { expense in
                                        ExpenseRowView(expense: expense)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                // Bakiyeler Görünümü
                VStack(spacing: 16) {
                    // Toplam borç özet kartı
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sana Borçlu Olunan")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("₺\(String(format: "%.0f", abs(calculateTotalDebt() ?? 0)))")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        Text("\(getBorclular()) sana ne kadar borçlu.gör")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .onTapGesture {
                        showingDebtDetail = true
                    }
                    
                    Text("Bakiyeler")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Kişilerin bakiyeleri
                    VStack(spacing: 8) {
                        ForEach(group.members, id: \.self) { member in
                            if let debt = group.calculateDebts()[member] {
                                HStack {
                                    // Profil resmi
                                    Image(systemName: "person.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    
                                    // Kişi adı ve durumu
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(member)
                                                .font(.headline)
                                            if member == viewModel.currentUser.name {
                                                Text("Ben")
                                                    .font(.caption)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.blue.opacity(0.2))
                                                    .foregroundColor(.blue)
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Borç miktarı
                                    Text(String(format: "%+.0f₺", debt))
                                        .font(.headline)
                                        .foregroundColor(debt >= 0 ? .green : .red)
                                }
                                .padding()
                                .background(Color(uiColor: .systemBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showingDebtDetail) {
                    NavigationView {
                        DebtDetailView(group: group, viewModel: viewModel)
                    }
                }
            }
            
            Spacer()
            
            // Harcama Ekle Butonu
            Button(action: { showingAddExpense = true }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddExpense) {
            GroupAddExpenseView(viewModel: viewModel)
        }
    }
    
    private func calculateMyExpenses() -> Double {
        let myExpenses = group.expenses.filter { $0.paidBy == viewModel.currentUser.name }
        return myExpenses.reduce(0) { $0 + $1.amount }
    }
    
    private func groupExpensesByDate() -> [(Date, [Expense])] {
        let grouped = Dictionary(grouping: group.expenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    // Toplam borç hesaplama
    private func calculateTotalDebt() -> Double? {
        let debts = group.calculateDebts()
        guard let myDebt = debts[viewModel.currentUser.name] else { return nil }
        return myDebt
    }
    
    // Borçlu kişileri bulma
    private func getBorclular() -> String {
        let debts = group.calculateDebts()
        let borclular = group.members.filter { member in
            if let debt = debts[member], debt < 0 {
                return true
            }
            return false
        }
        
        if borclular.isEmpty {
            return "Kimse"
        } else if borclular.count == 1 {
            return borclular[0]
        } else {
            return "\(borclular[0]) ve \(borclular.count - 1) kişi daha"
        }
    }
}

// Tab Butonu
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isSelected ? .primary : .gray)
                Rectangle()
                    .fill(isSelected ? Color.gray : Color.clear)
                    .frame(height: 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

// Özet Kartı
struct SummaryCard: View {
    let title: String
    let amount: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("₺\(String(format: "%.0f", amount))")
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// Harcama Satırı
struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            // Kategori ikonu
            CategoryIcon(category: expense.category)
                .font(.system(size: 24))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)
                Text("\(expense.paidBy) Tarafından Ödendi")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("₺\(String(format: "%.0f", expense.amount))")
                .font(.headline)
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
}

// Kategori İkonu
struct CategoryIcon: View {
    let category: ExpenseCategory
    
    var body: some View {
        switch category {
        case .food:
            Text("🍕")
        case .transportation:
            Text("⛽️")
        case .accommodation:
            Text("🏨")
        case .health:
            Text("💊")
        case .other:
            Text("💰")
        }
    }
} 