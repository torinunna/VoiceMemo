//
//  TimerViewModel.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/9/24.
//

import Foundation
import UIKit

class TimerViewModel: ObservableObject {
    @Published var isSettingTimer: Bool
    @Published var time: Time
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    var notificationService: NotificationService
    
    init(isSettingTimer: Bool = true, time: Time = .init(hours: 0, minutes: 0, seconds: 0), timer: Timer? = nil, timeRemaining: Int = 0, isPaused: Bool = false, notificationService: NotificationService = .init()) {
        self.isSettingTimer = isSettingTimer
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
        self.notificationService = notificationService
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
        
        var backgroundTaskID: UIBackgroundTaskIdentifier?
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            if let task = backgroundTaskID {
                UIApplication.shared.endBackgroundTask(task)
                backgroundTaskID = .invalid
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.notificationService.notify()
                
                if let task = backgroundTaskID {
                    UIApplication.shared.endBackgroundTask(task)
                    backgroundTaskID = .invalid
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
