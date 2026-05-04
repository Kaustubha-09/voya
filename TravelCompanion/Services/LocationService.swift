import CoreLocation
import SwiftUI

@MainActor
final class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()

    @Published var userLocation: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentCity: String = ""
    @Published var currentCountry: String = ""

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = manager.authorizationStatus
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestPermission()
            return
        }
        manager.requestLocation()
    }

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    var isDenied: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }

    func distance(to coordinates: Coordinates) -> Double? {
        guard let loc = userLocation else { return nil }
        let dest = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        return loc.distance(from: dest) / 1000
    }

    func formattedDistance(to coordinates: Coordinates) -> String? {
        guard let km = distance(to: coordinates) else { return nil }
        if km < 1    { return "< 1 km" }
        if km < 10   { return String(format: "%.1f km", km) }
        if km < 1000 { return "\(Int(km)) km away" }
        return String(format: "%.0f,000 km", km / 1000)
    }

    func nearbyStays(from stays: [Stay], withinKm limit: Double = 2000) -> [Stay] {
        guard userLocation != nil else { return [] }
        return stays
            .compactMap { stay -> (Stay, Double)? in
                guard let d = distance(to: stay.coordinates) else { return nil }
                return (stay, d)
            }
            .filter { $0.1 <= limit }
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
    }

    private func reverseGeocode(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self, let place = placemarks?.first else { return }
            Task { @MainActor in
                self.currentCity    = place.locality ?? place.administrativeArea ?? ""
                self.currentCountry = place.country ?? ""
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        Task { @MainActor in
            self.userLocation = loc
            self.reverseGeocode(loc)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            if manager.authorizationStatus == .authorizedWhenInUse ||
               manager.authorizationStatus == .authorizedAlways {
                manager.requestLocation()
            }
        }
    }
}
