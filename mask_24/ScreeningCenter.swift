import UIKit
import CoreLocation
import MapKit


class ScreeningCenter: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init (title: String, latitude: Double, longitude: Double) {
        self.title = title
        self.coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude
    }
}
