//
//  TimerView.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var timerService = TimerService.shared
    @EnvironmentObject var userService: UserService
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 25
    @State private var seconds: Int = 0
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Mock folder
    private let mockFolderId = "default_folder"

    var body: some View {
        NavigationStack {
            VStack {
                // User Coins Display
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("\(userService.currentUser?.coins ?? 0)")
                    Spacer()
                }
                .font(.title2)
                .padding()
                
                Spacer()

                // Countdown Display
                Text(timeString(from: timerService.remainingTime))
                    .font(.system(size: 80, weight: .thin, design: .monospaced))
                    .padding(.bottom, 40)
                
                // Timer Setup Picker
                if !timerService.isRunning && timerService.remainingTime == timerService.selectedDuration {
                    HStack {
                        Picker("Hours", selection: $hours) { ForEach(0..<24) { Text("\($0) h") } }.pickerStyle(.wheel)
                        Picker("Minutes", selection: $minutes) { ForEach(0..<60) { Text("\($0) m") } }.pickerStyle(.wheel)
                        Picker("Seconds", selection: $seconds) { ForEach(0..<60) { Text("\($0) s") } }.pickerStyle(.wheel)
                    }
                    .frame(height: 150)
                    .onChange(of: hours) { updateTimer() }
                    .onChange(of: minutes) { updateTimer() }
                    .onChange(of: seconds) { updateTimer() }
                }

                Spacer()

                // Action Buttons
                HStack(spacing: 20) {
                    if timerService.isRunning {
                        Button(action: { timerService.pauseTimer() }) {
                            Text("Pause").frame(maxWidth: .infinity)
                        }.buttonStyle(.bordered)
                        
                        Button(action: finishSession) {
                            Text("Finish").frame(maxWidth: .infinity)
                        }.buttonStyle(.borderedProminent)
                        
                    } else {
                        Button(action: { timerService.startTimer() }) {
                            Text("Start").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(timerService.remainingTime == 0 && timerService.selectedDuration == 0)

                        if timerService.selectedDuration != timerService.remainingTime {
                             Button(action: { timerService.resetTimer() }) {
                                Text("Reset").frame(maxWidth: .infinity)
                            }.buttonStyle(.bordered)
                        }
                    }
                }
                .padding([.horizontal, .bottom])
                
                // Mock Lap History
                List {
                    Text("Lap History (placeholder)")
                        .font(.headline)
                    Text("Session: 25 mins, +25 coins, +1 Clownfish")
                    Text("Session: 10 mins, +10 coins")
                }
                .listStyle(.plain)
                .frame(height: 150)
            }
            .navigationTitle("Focus Timer")
            .onAppear {
                // Initialize timer with default values
                if timerService.selectedDuration == 0 {
                    timerService.setTimer(hours: hours, minutes: minutes, seconds: seconds)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Session Finished"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func updateTimer() {
        timerService.setTimer(hours: hours, minutes: minutes, seconds: seconds)
    }
    
    private func finishSession() {
        Task {
            do {
                try await timerService.finishSession(folderId: mockFolderId)
                let elapsed = timerService.selectedDuration - timerService.remainingTime
                alertMessage = "Great job! You focused for \(timeString(from: elapsed)). Rewards will be shown once implemented."
                showingAlert = true
            } catch {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }
    
    private func timeString(from totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
