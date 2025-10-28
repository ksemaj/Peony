//
//  LocationManager.swift
//  Peony
//
//  Manages user location for accurate sunrise/sunset calculations
//

import Foundation
import CoreLocation
import Observation

/// Observable location manager that provides user coordinates for solar calculations
@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    /// Shared singleton instance
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    /// Current user latitude (defaults to San Diego if location unavailable)
    private(set) var latitude: Double = 32.7157  // San Diego default

    /// Current user longitude (defaults to San Diego if location unavailable)
    private(set) var longitude: Double = -117.1611  // San Diego default

    /// Whether location services are authorized
    private(set) var isAuthorized: Bool = false

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer  // Low accuracy is fine for solar calculations
        locationManager.distanceFilter = 10000  // Only update if user moves 10km+

        checkAuthorizationStatus()
    }

    /// Check current authorization status and request if needed
    func checkAuthorizationStatus() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            // Request permission on first launch
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isAuthorized = false
            // Keep using default coordinates
        @unknown default:
            isAuthorized = false
        }
    }

    /// Request location permission
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Update coordinates
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude

        // Notify TimeManager to recalculate sunrise/sunset
        TimeManager.shared.forceUpdate()

        // Stop continuous updates to save battery (we only need it once)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        // Keep using default coordinates
    }
}
