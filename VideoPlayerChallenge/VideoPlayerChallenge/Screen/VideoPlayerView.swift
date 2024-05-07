//
//  VideoPlayerView.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 02/05/2024.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @ObservedObject var viewModel: VideoPlayerViewModel
    
    public init(url: String) {
        self.viewModel = VideoPlayerViewModel(url: url)
    }
    
    var body: some View {
        VStack {
            VideoPlayer(player: viewModel.player)
                .task { // loading video and starting on background to avoid blocking mainthread
                    viewModel.setup()
                }.onDisappear {
                    viewModel.onDisappear()
                }.onShake {
                    viewModel.onShake()
                }
        }
    }
}

#Preview {
    VideoPlayerView(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")
}
