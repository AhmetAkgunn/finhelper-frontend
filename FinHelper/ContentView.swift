//
//  ContentView.swift
//  FinHelper
//
//  Created by Sühan Düşünceli on 13.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Cüzdan sekmesi
            WalletView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Cüzdan")
                }
                .tag(0)
            
            // Gruplar sekmesi
            GroupsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Gruplar")
                }
                .tag(1)
            
            // İstatistikler sekmesi
            StatsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("İstatistikler")
                }
                .tag(2)
            
            // Profil sekmesi
            ProfileView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
