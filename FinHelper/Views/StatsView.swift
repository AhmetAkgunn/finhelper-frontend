import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var selectedYear = "2024"
    @State private var showingMonthDetail = false
    @State private var selectedMonth: (String, Double)?
    @State private var showingYearPicker = false
    
    // Tüm yıllar
    let availableYears = ["2024", "2023", "2022", "2021", "2020"]
    
    // Örnek veriler
    let yearlyExpenses = [
        "2024": [
            ("ARALIK", 9450.0),
            ("KASIM", 25250.0),
            ("EKİM", 21540.0),
            ("EYLÜL", 18470.0),
            ("AĞUSTOS", 29635.0)
        ],
        "2023": [
            ("ARALIK", 15450.0),
            ("KASIM", 22250.0),
            ("EKİM", 18540.0),
            ("EYLÜL", 20470.0),
            ("AĞUSTOS", 24635.0)
        ],
        "2022": [
            ("ARALIK", 12450.0),
            ("KASIM", 19250.0),
            ("EKİM", 15540.0),
            ("EYLÜL", 17470.0),
            ("AĞUSTOS", 22635.0)
        ],
        "2021": [
            ("ARALIK", 11450.0),
            ("KASIM", 18250.0),
            ("EKİM", 14540.0),
            ("EYLÜL", 16470.0),
            ("AĞUSTOS", 21635.0)
        ],
        "2020": [
            ("ARALIK", 10450.0),
            ("KASIM", 17250.0),
            ("EKİM", 13540.0),
            ("EYLÜL", 15470.0),
            ("AĞUSTOS", 20635.0)
        ]
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Yıl seçici buton
                Button(action: { showingYearPicker = true }) {
                    HStack {
                        Text(selectedYear)
                            .font(.title2.bold())
                        Image(systemName: "chevron.down")
                            .font(.headline)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
                .sheet(isPresented: $showingYearPicker) {
                    NavigationView {
                        List(availableYears, id: \.self) { year in
                            Button(action: {
                                selectedYear = year
                                showingYearPicker = false
                            }) {
                                HStack {
                                    Text(year)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if year == selectedYear {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .navigationTitle("Yıl Seçin")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Kapat") {
                                    showingYearPicker = false
                                }
                            }
                        }
                    }
                }
                
                // Aylık harcamalar listesi
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(yearlyExpenses[selectedYear] ?? [], id: \.0) { month, amount in
                            Button(action: {
                                selectedMonth = (month, amount)
                                showingMonthDetail = true
                            }) {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text(month)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("₺\(String(format: "%.0f", amount))")
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    // İlerleme çubuğu
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(height: 8)
                                                .cornerRadius(4)
                                            
                                            Rectangle()
                                                .fill(Color.blue)
                                                .frame(width: calculateBarWidth(amount: amount, maxAmount: 30000, totalWidth: geometry.size.width), height: 8)
                                                .cornerRadius(4)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("İstatistikler")
            .sheet(isPresented: $showingMonthDetail) {
                if let (month, amount) = selectedMonth {
                    NavigationView {
                        MonthDetailView(month: month, amount: amount)
                    }
                }
            }
        }
    }
    
    private func calculateBarWidth(amount: Double, maxAmount: Double, totalWidth: CGFloat) -> CGFloat {
        let ratio = amount / maxAmount
        return CGFloat(ratio) * totalWidth
    }
}

// Kategori kartı bileşeni
struct CategoryCard: View {
    let icon: String
    let name: String
    let amount: String
    
    var body: some View {
        VStack {
            Text(icon)
                .font(.system(size: 30))
            Text(name)
                .font(.headline)
            Text(amount)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(width: 100, height: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
} 