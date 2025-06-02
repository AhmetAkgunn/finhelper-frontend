import SwiftUI

struct WalletAddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedCategory = ExpenseCategory.other
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                // Harcama başlığı
                Section(header: Text("Harcama Detayları")) {
                    TextField("Başlık", text: $title)
                    
                    HStack {
                        Text("₺")
                        TextField("Tutar", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("Kategori", selection: $selectedCategory) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    DatePicker("Tarih", selection: $selectedDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Harcama Ekle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Vazgeç") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Ekle") {
                        addExpense()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && !amount.isEmpty
    }
    
    private func addExpense() {
        // Veritabanı olmadığı için şimdilik boş
        dismiss()
    }
} 