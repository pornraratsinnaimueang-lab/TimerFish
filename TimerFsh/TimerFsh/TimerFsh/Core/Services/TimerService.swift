//
//  TimerService.swift
//  TimerFsh
//
//  Created by Gemini on 24/11/2025.
//

import Foundation
import Combine

final class TimerService: ObservableObject {
    @Published var remainingTime: Int = 0
    @Published var selectedDuration: Int = 0
    @Published var isRunning: Bool = false
    
    static let shared = TimerService()
    private var timerSubscription: AnyCancellable?

    private init() {}
    
    func setTimer(hours: Int, minutes: Int, seconds: Int) {
        guard !isRunning else { return }
        let totalSeconds = (hours * 3600) + (minutes * 60) + seconds
        self.selectedDuration = totalSeconds
        self.remainingTime = totalSeconds
    }

    func startTimer() {
        guard !isRunning, remainingTime > 0 else { return }
        isRunning = true
        
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    self.pauseTimer()
                }
            }
    }

    func pauseTimer() {
        isRunning = false
        timerSubscription?.cancel()
    }

    func resetTimer() {
        pauseTimer()
        remainingTime = selectedDuration
    }

    func finishSession(folderId: String) async throws {
        pauseTimer()
        let elapsedTime = selectedDuration - remainingTime
        guard elapsedTime > 5 else { // Require at least 5 seconds to get a reward
            resetTimer()
            throw URLError(.cancelled, userInfo: [NSLocalizedDescriptionKey: "Session too short to earn rewards."])
        }
        
        // Simple reward logic: 1 coin per 10 seconds, and a clownfish for any session > 60s
        let earnedCoins = elapsedTime / 10
        let rewardItem: String? = elapsedTime > 60 ? "fish_clownfish" : nil
        
        try await DatabaseService.shared.recordLapAndUpdateUser(
            duration: elapsedTime,
            earnedCoins: earnedCoins,
            rewardItem: rewardItem,
            folderId: folderId
        )
        
        // Reset timer for the next session
        resetTimer()
    }
}
