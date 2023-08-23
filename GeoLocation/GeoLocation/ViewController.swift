import UIKit
import MapKit
import CoreLocation

enum VisibleRegion {
    case focused
    case local
    case city
    case state
    case country
    case continent
}

class ViewController: UIViewController {
    
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    let trackingButton = MKUserTrackingButton()
    let tableView = UITableView()
    let mapInfoView = MapInfoView()
    var universities: [Feature] = []
    var selectedLocation: CLLocationCoordinate2D?
    var currentRoute: MKPolyline?
    var travelTime: Double?
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateCurrentLocation()
        fetchUniversityData()
        
        
    }
    
    private func setupView() {
        view.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.delegate = self
        
        trackingButton.mapView = map
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        trackingButton.layer.cornerRadius = 16
        trackingButton.clipsToBounds = true
        trackingButton.backgroundColor = .white
        map.addSubview(trackingButton)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isHidden = true
        
        view.addSubview(mapInfoView)
        mapInfoView.translatesAutoresizingMaskIntoConstraints = false
        mapInfoView.delegate = self
        
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.color = .tintColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            map.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackingButton.bottomAnchor.constraint(equalTo: map.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            trackingButton.trailingAnchor.constraint(equalTo: map.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 0),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mapInfoView.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 6),
            mapInfoView.heightAnchor.constraint(equalToConstant: 300),
            mapInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mapInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    func showTableView() {
        mapInfoView.isHidden = true
        tableView.isHidden = false
    }
    
    func showMapInfoView() {
        mapInfoView.isHidden = false
        tableView.isHidden = true
    }
    
    func updateMapInfoView(_ university: Feature) {
        
        mapInfoView.setTextFor(title: university.attributes.University_Chapter, subTitle1: university.attributes.MEVR_RD, subTitle2: "\(university.attributes.City), \(university.attributes.State)", subTitle3: "More info")
        showMapInfoView()
    }
    
    private func updateCurrentLocation() {
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    print("#ViewController Logs - Unable to fetch location data")
                    return
                }
                
                strongSelf.setRegion(with: location, visibleRegion: .country)
                strongSelf.setGeoTitle(with: location)
                LocationManager.shared.resolveLocationName(with: location) { placeMark in
                    strongSelf.mapInfoView.setTextFor(title: placeMark?.name ?? "NotFound", subTitle1: placeMark?.thoroughfare ?? "Not Found", subTitle2: placeMark?.administrativeArea ?? "Not Found", subTitle3: "More info")
                }
                
            }
        }
    }
    
    private func fetchUniversityData() {
        ArcGIS_API.shared.fetchLocationData { [weak self] response in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    print("#ViewController Logs - Unable to fetch API location data")
                    return
                }
                
                for item in response.features {
                    let universityLocation = CLLocation(latitude: item.geometry.y, longitude: item.geometry.x)
                    strongSelf.addMapPin(with: universityLocation, title: item.attributes.University_Chapter, subTitle: item.attributes.ChapterID, univiersity: item)
                    strongSelf.universities.append(item)
                }
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    func addMapPin(with location: CLLocation, title: String?, subTitle: String?, univiersity: Feature) {
        let destinationAnnotation = MapAnnotation()
        destinationAnnotation.title = title
        destinationAnnotation.subtitle = subTitle
        destinationAnnotation.coordinate = location.coordinate
        destinationAnnotation.university = univiersity
        
        map.addAnnotation(destinationAnnotation)
        
    }
    
    func setRegion(with location: CLLocation, visibleRegion: VisibleRegion) {
        var delta: Double
        switch visibleRegion {
        case .focused:
            delta = 0.0005
        case .local:
            delta = 0.005
        case .city:
            delta = 0.05
        case .state:
            delta = 0.5
        case .country:
            delta = 5
        case .continent:
            delta = 60
        }
        map.setRegion(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: delta,
                longitudeDelta: delta)),
                      animated: true)
    }
    
    func setGeoTitle(with location: CLLocation) {
        LocationManager.shared.resolveLocationName(with: location) { [weak self] placeMark in
            self?.title = placeMark?.name
        }
    }
    
    // Function to calculate and display the route
    func showRoute(to destination: CLLocationCoordinate2D) {
        guard let currentLocation = map.userLocation.location else {
            print("#ViewController Logs - Current location not available")
            return
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        if let currentRoute = currentRoute {
            map.removeOverlay(currentRoute)
        }
        
        spinner.startAnimating()
        let directions = MKDirections(request: directionRequest)
        DispatchQueue.global().async {
            directions.calculate { (response, error) in
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    guard let route = response?.routes.first else {
                        print("#ViewController Logs - Route not found")
                        let alert =  UIAlertController(title: "Route not Found!", message: "Please try later", preferredStyle: .alert)
                        let dismissAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(dismissAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    let edgePadding = UIEdgeInsets(top: 80 , left: 40, bottom: 40, right: 40)
                    self.currentRoute = route.polyline
                    self.map.addOverlay(self.currentRoute!)
                    self.map.setVisibleMapRect(self.currentRoute!.boundingMapRect, edgePadding: edgePadding, animated: true)
                    self.mapInfoView.setDistance(route.distance, travelTime: route.expectedTravelTime)
                }
            }
        }
    }
}

extension ViewController: MapInfoViewDelegate {
    func navigate() {
        showRoute(to: selectedLocation!)
    }
    
    func showUniversities() {
        showTableView()
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Handle pin selection here
        view.canShowCallout = true
        if let annotation = view.annotation as? MapAnnotation {
            // Perform actions based on the selected annotation
            print("#ViewController Logs - Pin clicked - Title: \(String(describing: annotation.coordinate))")
            
            let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            setRegion(with: location, visibleRegion: .focused)
            setGeoTitle(with: location)
            selectedLocation = location.coordinate
            let university = annotation.university
            updateMapInfoView(university!)
            showMapInfoView()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red.withAlphaComponent(0.6)
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else {
            return nil
        }
        
        let identifier = "MapAnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Create the "Show Direction" button
            let directionButton = UIButton(type: .detailDisclosure)
            directionButton.translatesAutoresizingMaskIntoConstraints = false
            directionButton.setTitle("       Navigate", for: .normal)
            directionButton.addTarget(self, action: #selector(showDirection), for: .touchUpInside)
            annotation.showDirectionButton = directionButton
            
            annotationView?.detailCalloutAccessoryView = directionButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    //  Action method for the "Show Direction" button
    @objc func showDirection() {
        showRoute(to: selectedLocation!)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let university = universities[indexPath.row]
        content.text = [university.attributes.University_Chapter, university.attributes.City, university.attributes.State].compactMap { $0 }.joined(separator: ", ")
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("#ViewController Logs - Cell selected at index:\(indexPath.row)")
        let university = universities[indexPath.row]
        let location = CLLocation(latitude: university.geometry.y, longitude: university.geometry.x)
        setGeoTitle(with: location)
        setRegion(with: location, visibleRegion: .state)
        selectedLocation = location.coordinate
        updateMapInfoView(university)
    }
}

class MapAnnotation: MKPointAnnotation {
    var showDirectionButton: UIButton?
    var university: Feature?
}
