//
//  HomePageView.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Welcome to TimerFish!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Your personal focus companion.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                NavigationLink(destination: TimerView()) {
                    Label("Start Focus Session", systemImage: "timer")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
            }
            .padding()
            .navigationTitle("Homepage")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomePageView()
}
