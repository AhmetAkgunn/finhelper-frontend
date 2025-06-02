import SwiftUI

struct WalletView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showingAddExpense = false
    @State private var showingExpenseDetail = false
    @State private var selectedExpense: ExpenseRow.Data?
    
    var body: some View {
        NavigationView {
            VStack {
                // Kullanıcı profil bilgisi
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text(viewModel.currentUser.name)
                            .font(.headline)
                        Text("Aylık Harcamalarım")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                
                // Toplam harcama göstergesi
                Text("₺9.450")
                    .font(.system(size: 40, weight: .bold))
                    .padding()
                
                // Harcama listesi
                List {
                    ForEach([
                        ExpenseRow.Data(id: UUID(), title: "Benzin", amount: 3000, date: "24 Aralık 2024", icon: "⛽️"),
                        ExpenseRow.Data(id: UUID(), title: "Pizza", amount: 640, date: "20 Aralık 2024", icon: "🍕"),
                        ExpenseRow.Data(id: UUID(), title: "Otel", amount: 5250, date: "20 Aralık 2024", icon: "🏨"),
                        ExpenseRow.Data(id: UUID(), title: "Eczane", amount: 380, date: "18 Aralık 2024", icon: "💊")
                    ]) { expense in
                        ExpenseRow(data: expense)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedExpense = expense
                                showingExpenseDetail = true
                            }
                    }
                    .onDelete { indexSet in
                        // Silme işlemi veritabanı olmadığı için şimdilik boş
                    }
                }
            }
            .navigationTitle("Cüzdan")
            .toolbar {
                Button(action: { showingAddExpense = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            WalletAddExpenseView()
        }
        .sheet(isPresented: $showingExpenseDetail) {
            if let expense = selectedExpense {
                ExpenseDetailView(expense: expense)
            }
        }
    }
}

// Harcama satırı bileşeni
struct ExpenseRow: View {
    struct Data: Identifiable {
        let id: UUID
        let title: String
        let amount: Double
        let date: String
        let icon: String
    }
    
    let data: Data
    
    var body: some View {
        HStack {
            Text(data.icon)
                .font(.title)
            VStack(alignment: .leading) {
                Text(data.title)
                    .font(.headline)
                Text(data.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("₺\(String(format: "%.2f", data.amount))")
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

// Harcama detay görünümü
struct ExpenseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let expense: ExpenseRow.Data
    @State private var title: String
    @State private var amount: String
    
    init(expense: ExpenseRow.Data) {
        self.expense = expense
        _title = State(initialValue: expense.title)
        _amount = State(initialValue: String(format: "%.2f", expense.amount))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Harcama Detayları")) {
                    HStack {
                        Text(expense.icon)
                            .font(.title)
                        TextField("Başlık", text: $title)
                    }
                    
                    HStack {
                        Text("₺")
                        TextField("Tutar", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Text("Tarih")
                        Spacer()
                        Text(expense.date)
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button(action: saveChanges) {
                        Text("Değişiklikleri Kaydet")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.blue)
                    }
                    .disabled(true) // Veritabanı olmadığı için şimdilik devre dışı
                }
            }
            .navigationTitle("Harcama Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Vazgeç") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        // Veritabanı olmadığı için şimdilik boş
        dismiss()
    }
} 