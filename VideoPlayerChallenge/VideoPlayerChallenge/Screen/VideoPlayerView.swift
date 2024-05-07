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
    
    public init() {
        self.viewModel = VideoPlayerViewModel()
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: viewModel.player)
                .task { // loading video and starting on background to avoid blocking mainthread
                    viewModel.setup()
                }.onDisappear {
                    viewModel.onDisappear()
                }.onShake {
                    viewModel.onShake()
                }
            if viewModel.showLoader {
                ProgressView("Loading...").tint(.white)
                    .foregroundColor(.white)
                    .scaleEffect(3)
            }
        }
    }
}

#Preview {
    VideoPlayerView()
}
