//
//  TimerViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/9/24.
//

import Foundation

class TimerViewModel: ObservableObject {
    @Published var isSettingTimer: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    
    init(isSettingTimer: Bool = true, time: Time = .init(hours: 0, minutes: 0, seconds: 0), timer: Timer? = nil, timeRemaining: Int = 0, isPaused: Bool = false) {
        self.isSettingTimer = isSettingTimer
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
    }
}

extension TimerViewModel {
    func settingBtnTapped() {
        isSettingTimer = false
        timeRemaining = time.convertedSeconds
        startTimer()
    }
    
    func cancelBtnTapped() {
        stopTimer()
        isSettingTimer = true
    }
    
    func pauseOrRestartBtnTapped() {
        if isPaused {
        
        } else {
            stopTimer()
        }
        isPaused.toggle()
    }
}

private extension TimerViewModel {
    func startTimer() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
