//
//  MainTabView.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Label("Homepage", systemImage: "house.fill")
                }
            
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

            // New Fish Tank Minigame Placeholder Tab
            Text("Fish Tank Minigame Placeholder")
                .tabItem {
                    Label("Aquarium", systemImage: "aquarium") // Using "aquarium" system image
                }

            StoreView()
                .tabItem {
                    Label("ร้านค้า", systemImage: "cart")
                }

            // Existing ProfileView
            ProfileView()
                .tabItem {
                    Label("โปรไฟล์", systemImage: "person.crop.circle")
                }
        }
    }
}
