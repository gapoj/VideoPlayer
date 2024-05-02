//
//  VideoPlayerView.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 02/05/2024.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")
    var body: some View {
        if let url {
            let videoplayer = AVPlayer(url:url)
            VideoPlayer(player: videoplayer ).onAppear {
                videoplayer.play()
            }
        }
    }
}

#Preview {
    VideoPlayerView()
}
