//
//  VideoPlayerViewModel.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 04/05/2024.
//

import Foundation
import AVKit
import CoreLocation

final class VideoPlayerViewModel: NSObject, ObservableObject {
    
    @Published var player: AVPlayer  = AVPlayer()
    var locationManager = CLLocationManager()
    var lastlocation: CLLocation?
    
    public init(url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
        }
    }
    func onAppear() {
        checkLocationAuthorization()
        player.play()
    }
    func onDisappear() {
        player.pause()
    }
    func onShake() {
        player.pause()
    }
    func restartVideo() {
        player.seek(to: .zero)
    }
    func checkLocationAuthorization() {
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        switch locationManager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            lastlocation = locationManager.location
            
        @unknown default:
            print("Location service disabled")
            
        }
    }
}
extension VideoPlayerViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastlocation,
           let current = locations.first,
           lastlocation.distance(from: current).magnitude > 10 {
            self.lastlocation = current
            restartVideo()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function, error)
    }
}
