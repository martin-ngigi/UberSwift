//
//  LocationManager.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    /**Intialze location manager**/
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // precise location
        locationManager.requestWhenInUseAuthorization() // request user's location permission
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    /**For updating user's location in the app**/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
//        print(locations.first)
        locationManager.startUpdatingLocation()
    }
}
