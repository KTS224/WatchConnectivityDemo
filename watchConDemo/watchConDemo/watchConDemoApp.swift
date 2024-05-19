//
//  watchConDemoApp.swift
//  watchConDemo
//
//  Created by 김태성 on 4/9/24.
//

import SwiftUI
import AVKit

@main
struct watchConDemoApp: App {
//    @StateObject var userStore = UserStore()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environmentObject(userStore)
        }
    }
}

// AppDelegate
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    do {
//      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
//      print("Playback OK")
//      try AVAudioSession.sharedInstance().setActive(true)
//      print("Session is Active")
//    } catch {
//      print(error)
//    }
//    return true
//  }
//}
