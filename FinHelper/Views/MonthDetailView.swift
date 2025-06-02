import SwiftUI

struct MonthDetailView: View {
    let month: String
    let amount: Double
    @Environment(\.dismiss) private var dismiss
    
    // Örnek kategori dağılımı
    let categories = [
        ("Yemek", "🍽️", 3450.0),
        ("Ulaşım", "🚗", 2800.0),
        ("Ev", "🏠", 1500.0),
        ("Eğlence", "🎮", 1200.0),
        ("Sağlık", "💊", 500.0)
    ]
    
    // Örnek harcama geçmişi
    let expenses = [
        ("Benzin", "⛽️", 3000.0, "24 Aralık"),
        ("Pizza", "🍕", 640.0, "20 Aralık"),
        ("Otel", "🏨", 5250.0, "20 Aralık"),
        ("Eczane", "💊", 380.0, "18 Aralık")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Ay özeti
                VStack(spacing: 8) {
                    Text(month)
                        .font(.title2.bold())
                    Text("₺\(String(format: "%.0f", amount))")
                        .font(.title.bold())
                        .foregroundColor(.blue)
                }
                .padding()
                
                // Kategori dağılımı
                VStack(alignment: .leading, spacing: 16) {
                    Text("Kategori Dağılımı")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(categories, id: \.0) { category, icon, amount in
                                VStack {
                                    Text(icon)
                                        .font(.system(size: 30))
                                    Text(category)
                                        .font(.headline)
                                    Text("₺\(String(format: "%.0f", amount))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Harcama geçmişi
                VStack(alignment: .leading, spacing: 16) {
                    Text("Harcama Geçmişi")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(expenses, id: \.0) { title, icon, amount, date in
                            HStack {
                                Text(icon)
                                    .font(.title2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(title)
                                        .font(.headline)
                                    Text(date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("₺\(String(format: "%.0f", amount))")
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Kapat") {
                    dismiss()
                }
            }
        }
    }
} 