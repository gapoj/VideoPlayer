//
//  VIew+Extension.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 06/05/2024.
//

import SwiftUI

// A View extension to make the shake modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
