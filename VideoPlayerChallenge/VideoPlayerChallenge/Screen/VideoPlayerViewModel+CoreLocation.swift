//
//  VideoPlayerViewModel+CoreLocation.swift
//  VideoPlayerChallenge
//
//  Created by Guillermo Apoj on 06/05/2024.
//

import CoreLocation

private extension Double {
    static let distanceThreshold: Double = 10
}
// CLLocationManagerDelegate
extension VideoPlayerViewModel: CLLocationManagerDelegate {
    func checkLocationAuthorization() {
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = .distanceThreshold // distance Filter is useful to reduce the usage but is not 100% reliable so I double check on didUpdate
        
        switch locationManager.authorizationStatus { // separating restricted from denied to try them as a different case but is out of the scope of the excersice
        case .notDetermined://The user choose allow or denny your app to get the location yet
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print(#function,"Location restricted")
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode, may do something to send it to change the configurastion but I think is out of the scope of the exercise
            print(#function,"Location denied")
        case .authorizedAlways, .authorizedWhenInUse:
            lastlocation = locationManager.location
        @unknown default:
            print(#function,"Location service disabled")
            
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastlocation,
           let current = locations.last, // in case there is more than one I use the last guided by apple documentation
           lastlocation.distance(from: current).magnitude >= .distanceThreshold { // distance Filter is not 100% reliable so I double check here
            self.lastlocation = current
            restartVideo()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // in a real world up we should do something with this at least log it
        print(#function, error)
    }
}
