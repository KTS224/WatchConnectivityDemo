//
//  AudioSessionManager.swift
//  watchConDemo
//
//  Created by 김태성 on 4/14/24.
//

import SwiftUI
import AVFoundation


class AudioSessionManager: ObservableObject {
    @Published var isAirPodsConnected: Bool = false

    init() {
        setupNotifications()
        checkInitialHeadphoneState()
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioRouteChangeListener),
            name: AVAudioSession.routeChangeNotification,
            object: nil)
    }

    private func checkInitialHeadphoneState() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        isAirPodsConnected = currentRoute.outputs.contains { $0.portType == .bluetoothA2DP && $0.portName.contains("AirPods") }
    }

    @objc private func audioRouteChangeListener(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        if reason == .newDeviceAvailable || reason == .oldDeviceUnavailable {
            checkInitialHeadphoneState()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
