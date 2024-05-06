//
//  VideoPlayerViewModel.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 04/05/2024.
//

import Foundation
import AVKit
import CoreMotion

private extension Double {
    static let timeStep: Double = 3 // could be more but the video is no so long so
    static let motionUpdate: Double = 1
    static let minAngleThreshold: Double =  0.0872664626 // aprox 5 degrees
}
private extension Float {
    static let maxVolume: Float = 1
    static let minVolume: Float = 0
    static let volumeStep: Float = 0.01
}
final class VideoPlayerViewModel: NSObject, ObservableObject {
    
    // MARK: - Variables
    @Published var player: AVPlayer  = AVPlayer()
    var locationManager = CLLocationManager()
    var lastlocation: CLLocation?
    var motionManager = CMMotionManager()
    var initialAttitude: CMAttitude?
    let queue = OperationQueue()
    
    
    // MARK: - Initializers
    public init(url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)// video could be downloaded to local disk but I am avoiding the use of the disk
        }
    }
    // MARK: - Motion Tracking
    func updateVolume(for angle: Double) {
        if abs(angle) > .minAngleThreshold {
            if angle < 0 {
                increaseVolume()
            } else {
                decreaseVolume()
            }
        }
    }
    func updateTime(for angle: Double) {
        guard abs(angle) > .minAngleThreshold else { return }
        if angle < 0 {
            seekForward()
        } else {
            seekBackward()
        }
    }
    
    func startMotionTracking() {
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = .motionUpdate // updates 3 times a second to avoid over update
            motionManager.startDeviceMotionUpdates(
                using: .xArbitraryZVertical,
                to: queue
            ) {// this include the gyroscope and also the accelerometer so I think is better
                [weak self] (data, error) in
                
                guard let self, let data, error == nil else {
                    return
                }
                guard let initialAttitude else {
                    // the initialAttitude is nil so I initialize it to compare later
                    self.initialAttitude = data.attitude
                    return
                }
                // translate the attitude, to make it in comparation to the initial value so we have a reference, the function doesn't return so the data is modified there
                data.attitude.multiply(byInverseOf: initialAttitude)
                updateTime(for: data.attitude.yaw)
                updateVolume(for: data.attitude.pitch)
            }
        }
    }
    
    // MARK: - View Events
    func onAppear() {
        checkLocationAuthorization()
        player.play()
        startMotionTracking()
    }
    func onDisappear() {
        player.pause()
        motionManager.stopDeviceMotionUpdates()
        locationManager.stopUpdatingLocation()
    }
    // I could do play or pause depending on the current status but the PDF saids "A shake of the device should pause the video." so ....
    func onShake() {
        player.pause()
    }
    
    // MARK: - Video controls
    func restartVideo() {
        initialAttitude = nil // restarting all including the reference attitude
        player.pause()
        player.seek(to: .zero)
        player.play()
    }
    func decreaseVolume() {
        player.volume = max(self.player.volume - .volumeStep, .minVolume)
    }
    func increaseVolume() {
        player.volume = min(self.player.volume + .volumeStep, .maxVolume)
    }
    func seekForward() {
        guard let duration = player.currentItem?.duration else { return }
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime,
                                CMTime(seconds: .timeStep, preferredTimescale: currentTime.timescale))
        player.seek(to: max(duration, newTime),
                    toleranceBefore: CMTime.zero,
                    toleranceAfter: CMTime.zero)
    }
    
    func seekBackward() {
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTime(seconds: .timeStep, preferredTimescale: currentTime.timescale))
        print(#function, newTime)
        player.seek(to: max(newTime, CMTime.zero),
                    toleranceBefore: CMTime.zero,
                    toleranceAfter: CMTime.zero)
    }
}
