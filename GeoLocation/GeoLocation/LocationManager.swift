import CoreLocation
import UIKit
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping((CLLocation) -> Void)) {
        self.completion = completion
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        print("#LocationManager Logs - started updating location")
    }
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations:
                          [CLLocation]) {
        guard let location = locations.first else {
            print("#LocationManager Logs - location not found")
            return
        }
        print("#LocationManager Logs - location:\(location.coordinate)")
        completion?(location)
        manager.stopUpdatingLocation()
        print("#LocationManager Logs - stopped updating location")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        case .denied, .restricted:
            displayAccessDeniedAlert()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    public func resolveLocationName(with location: CLLocation,
                                    completion: @escaping ((CLPlacemark?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current ) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    func displayAccessDeniedAlert() {
        let alertController = UIAlertController(title: "Location Access Denied", message: "This app requires location access to use, please grant location access in the Settings app.", preferredStyle: .alert)
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alertController, animated: true)
    }
}
