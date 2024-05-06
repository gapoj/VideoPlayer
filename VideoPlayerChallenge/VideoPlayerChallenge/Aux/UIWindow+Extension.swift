//
//  UIWindow+Extension.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 06/05/2024.
//

import SwiftUI

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}
