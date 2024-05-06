//
//  UIDevice+Extension.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 06/05/2024.
//

import SwiftUI

// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}
