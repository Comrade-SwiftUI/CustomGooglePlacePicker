//
//  ViewController.swift
//  CustomGooglePlacePicker
//
//  Created by Bhavesh_iOS on 19/08/19.
//  Copyright © 2019 Bhavesh_iOS. All rights reserved.
//

import UIKit
import GoogleMaps


class VacationDestination: NSObject{
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.location = location
        self.zoom = zoom
    }
    
}


class ViewController: UIViewController{
    ///@IBOutlet weak var CustomSearchView: UIView!
    @IBOutlet weak var txtCurrentLocation: SearchTextField!
    @IBOutlet weak var myMapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    var userCurrentLocation : CLLocation!
    var sourceAddress : String!
    var destinationAddress : String!
    var locationMarker: GMSMarker!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    var mapTasks = MapRouteTasks()
    var listenToGPSUpdate : Bool!
    
    var arrPlace = [Place]()
  
    // MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
      
        myMapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.myMapView.animate(toZoom: 5)
        listenToGPSUpdate = false;

        let camera = GMSCameraPosition.camera(withLatitude:28.617220 , longitude:77.208099 , zoom: 18.0)
        myMapView = GMSMapView.map(withFrame: .zero, camera: camera)
        //self.view = myMapView
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:28.617220 , longitude: 77.208099))
        marker.title = "Indian Parliament"
        marker.snippet = "New Delhi, India"
        marker.map = myMapView
        
        txtCurrentLocation.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
 
    
    
    // MARK: -textFieldDidChange
    @objc func textFieldDidChange(_ textField: UITextField){
        if textField.text != ""{
            callSearchPlace(searchStr: textField.text!)
        }
    }
    
    // MARK: -textFieldShouldReturn
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: -callSearchPlace
    func callSearchPlace(searchStr: String){
        NetworkManager.shared.doSearchPlace(searchString: searchStr) {[weak self](responseObject, isSuccess, httpResponse) in
            guard let strongSelf = self else {return}
            if let arrPredication = responseObject?["predictions"]as? [[String : Any]]{
                strongSelf.arrPlace = Mapper<Place>().mapArray(JSONArray: arrPredication)
                strongSelf.txtCurrentLocation.filterStrings(strongSelf.arrPlace.compactMap({$0.description}))
            }
        }
    }
    

    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.txtCurrentLocation.text = lines.joined(separator: " ")
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setuplocationMarker(coordinate: CLLocationCoordinate2D) {
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
        locationMarker.map = myMapView
        locationMarker.title = "Your current location"
    }
    
    private func configureMapAndMarkersForRoute() {
        myMapView.camera = GMSCameraPosition.camera(withTarget: mapTasks.originCoordinate, zoom: 9.0)
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.myMapView
        originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.myMapView
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker.title = self.mapTasks.destinationAddress
    }
    
    private func drawRoute() {
        setuplocationMarker(coordinate: userCurrentLocation.coordinate)
        let route = mapTasks.overviewPolyline["points"] as! String
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = myMapView
    }
    
    private func clearMapView(){
        myMapView.clear()
        myMapView.camera = GMSCameraPosition(target: userCurrentLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        setuplocationMarker(coordinate: userCurrentLocation.coordinate)
    }
    
    private func displayRouteInfo() {
        self.txtCurrentLocation.text = mapTasks.totalDuration
    }
    
 /*   func showRouteToUserInner(waypoints : Array<String>) {
        self.destinationAddress = destAdd.text!
        self.sourceAddress = sourceAdd.text!
        mapTasks.getDirections(origin: sourceAddress, destination: destinationAddress, waypoints: waypoints, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                self.clearMapView()
                self.configureMapAndMarkersForRoute()
                self.drawRoute()
                self.displayRouteInfo()
            }
            else {
                print(status)
            }
        })
    }
   */
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        myMapView.isMyLocationEnabled = true
        myMapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userCurrentLocation = locations.first  else {
            return
        }
        self.userCurrentLocation = userCurrentLocation
        if(self.listenToGPSUpdate) {
            myMapView.camera = GMSCameraPosition(target: userCurrentLocation.coordinate, zoom: 10, bearing: 0, viewingAngle: 0)
           /*
            if(!self.shouldReRoute()) {
                self.showRouteDeviatedPopUp(self.userCurrentLocation.coordinate)
            }
            */
        }
        
        //locationManager.stopUpdatingLocation()
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = "I added this with a long tap"
        marker.snippet = ""
        marker.map = mapView
    }
}

