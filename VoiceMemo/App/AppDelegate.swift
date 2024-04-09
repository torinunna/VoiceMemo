//
//  AppDelegate.swift
//  VoiceMemo
//
//  Created by YUJIN KWON on 4/9/24.
//

import UIKit
 
class AppDelegate: NSObject, UIApplicationDelegate {
    var notiDelegate = NotificationDelete()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = notiDelegate
        return true
    }
}
