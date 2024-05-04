//
//  VideoPlayerViewModel.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 04/05/2024.
//

import Foundation
import AVKit

final class VideoPlayerViewModel: ObservableObject {
    
    @Published var player: AVPlayer
    
    public init(url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
        } else {
            player = AVPlayer()
        }
    }
    func onAppear() {
        player.play()
    }
    func onDisappear() {
        player.pause()
    }
    func onShake() {
        player.pause()
    }
}
