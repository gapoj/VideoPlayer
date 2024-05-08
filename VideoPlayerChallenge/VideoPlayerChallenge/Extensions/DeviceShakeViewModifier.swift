//
//  DeviceShakeViewModifier.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 06/05/2024.
//

import SwiftUI

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}
