import SwiftUI

struct GroupAddExpenseView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedCategory = ExpenseCategory.other
    @State private var selectedDate = Date()
    @State private var paidBy = ""
    @State private var splitEqually = true
    @State private var selectedMembers: Set<String> = []
    
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
                
                // Ödeme yapan kişi
                Section(header: Text("Ödeyen")) {
                    Picker("Ödeyen", selection: $paidBy) {
                        ForEach(viewModel.selectedGroup?.members ?? [], id: \.self) { member in
                            Text(member).tag(member)
                        }
                    }
                }
                
                // Bölüşme seçenekleri
                Section(header: Text("Bölüşme")) {
                    Toggle("Eşit Olarak Böl", isOn: $splitEqually)
                    
                    if !splitEqually {
                        ForEach(viewModel.selectedGroup?.members ?? [], id: \.self) { member in
                            Toggle(member, isOn: Binding(
                                get: { selectedMembers.contains(member) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedMembers.insert(member)
                                    } else {
                                        selectedMembers.remove(member)
                                    }
                                }
                            ))
                        }
                    }
                }
            }
            .navigationTitle("Harcama Ekle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Vazgeç") {
                        presentationMode.wrappedValue.dismiss()
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
        !title.isEmpty && !amount.isEmpty && !paidBy.isEmpty &&
        (splitEqually || (!splitEqually && !selectedMembers.isEmpty))
    }
    
    private func addExpense() {
        guard let amountValue = Double(amount),
              let group = viewModel.selectedGroup else { return }
        
        let splitBetween = splitEqually ? group.members : Array(selectedMembers)
        
        viewModel.addExpense(
            to: group,
            title: title,
            amount: amountValue,
            paidBy: paidBy,
            splitBetween: splitBetween,
            category: selectedCategory
        )
        
        presentationMode.wrappedValue.dismiss()
    }
} 
