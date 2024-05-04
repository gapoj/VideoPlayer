//
//  VideoPlayerChallengeApp.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 02/05/2024.
//

import SwiftUI

@main
struct VideoPlayerChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            VideoPlayerView(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")
        }
    }
}
