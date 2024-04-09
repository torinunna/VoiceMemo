//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 3/29/24.
//

import SwiftUI

@main
struct VoiceMemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
