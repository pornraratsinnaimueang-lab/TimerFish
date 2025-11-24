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
