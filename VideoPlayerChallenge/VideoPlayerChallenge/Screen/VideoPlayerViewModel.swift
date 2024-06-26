//
//  VideoPlayerViewModel.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 04/05/2024.
//

import Foundation
import AVKit
import CoreMotion
import Combine
import MediaPlayer

private extension Double {
    static let timeStep: Double = 3 // could be more but the video is no so long so
    static let motionUpdate: Double = 0.20 // updates 5 times a second to avoid over update
}
private extension Float {
    static let maxVolume: Float = 1
    static let minVolume: Float = 0
    static let volumeStep: Float = 0.25 // could be more gradual but for the sake of the excersice we have 4 volume stages, change this if you want a more gradual change of volume
}

final class VideoPlayerViewModel: NSObject, ObservableObject, AVAssetResourceLoaderDelegate {
    let increaseRange = 3.14...5.78
    let decreseRange = 0.50...3.14
    // MARK: - Variables
    @Published var player: AVPlayer?
    @Published var showLoader: Bool = true
    var locationManager = CLLocationManager()
    var lastlocation: CLLocation?
    var motionManager = CMMotionManager()
    let queue = OperationQueue()
    let url: String = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"
    private var cancellable: AnyCancellable?
    
    // MARK: - Initializers
    override public init() {
        super.init()
        checkLocationAuthorization() // so it shows the authorization when is loading
    }
    deinit {
        stopManagers()
        cancellable = nil
    }
    // MARK: - Motion Tracking
    func updateTime(_ rotation: Double) {
        if decreseRange.contains(rotation) {
            seekBackward()
        } else if increaseRange.contains(rotation) {
            seekForward()
        }
    }
    
    func updateVolume(_ rotation: Double) {
        if decreseRange.contains(rotation) {
            decreaseVolume()
        } else if increaseRange.contains(rotation) {
            increaseVolume()
        }
    }
    
    func startMotionTracking() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = .motionUpdate
            motionManager.startDeviceMotionUpdates(to: .main
            ) {// this include the gyroscope and also the accelerometer so I think is better
                [weak self] (data, error) in
                
                guard let self, let data, error == nil else {
                    return
                }
                //rotation along the z-axis controls the current time
                let rotationOnZ = atan2(data.gravity.x, data.gravity.y) + Double.pi
                // rotation along the x-axis should control the volume of the sound.
                let rotationOnX = atan2(data.gravity.z, data.gravity.y) + Double.pi
                updateTime(rotationOnZ)
                updateVolume(rotationOnX)
            }
        }
    }
    
    // MARK: - View Events
    func setup() {
        guard player == nil else { return } // extra defensive code just in case
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)// video could be downloaded to local disk but I am avoiding the use of the disk
            cancellable = player?.publisher(for: \.currentItem?.status)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] status in
                    guard let self else { return }
                    switch status {
                    case .readyToPlay:
                        showLoader = false
                        cancellable = nil // take out the loader no need to keep listening
                    default:
                        break
                    }
                }
            player?.volume = .maxVolume
            MPVolumeView.setVolume(.maxVolume)
            player?.play()
            startMotionTracking()
        }
    }
    func stopManagers() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func onDisappear() {
        player?.pause()
        stopManagers()
    }
    // I could do play or pause depending on the current status but the PDF saids "A shake of the device should pause the video." so ....
    func onShake() {
        player?.pause()
    }
    
    // MARK: - Video controls
    func restartVideo() {
        player?.seek(to: .zero)
    }
    func decreaseVolume() {
        MPVolumeView.setVolume(max(AVAudioSession.sharedInstance().outputVolume - .volumeStep, .minVolume))
    }
    func increaseVolume() {
        MPVolumeView.setVolume(min(AVAudioSession.sharedInstance().outputVolume + .volumeStep, .maxVolume))
    }
    func seekForward() {
        
        guard let player, let duration = player.currentItem?.duration else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime,
                                CMTime(seconds: .timeStep, 
                                       preferredTimescale: currentTime.timescale))
        player.seek(to: min(duration, newTime),
                    toleranceBefore: CMTime.zero,
                    toleranceAfter: CMTime.zero)
    }
    
    func seekBackward() {
        guard let player else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: .timeStep,
                                                         preferredTimescale: currentTime.timescale))
        player.seek(to: max(newTime, CMTime.zero),
                    toleranceBefore: CMTime.zero,
                    toleranceAfter: CMTime.zero)
    }
}
