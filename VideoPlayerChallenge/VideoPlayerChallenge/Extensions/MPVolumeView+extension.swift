//
//  MPVolumeView+extension.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 08/05/2024.
//

import MediaPlayer
// I use this extension to change the system audio rather than the player audio to make a greater impact in the demo.
extension MPVolumeView {
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
