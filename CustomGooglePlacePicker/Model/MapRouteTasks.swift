//
//  MapRouteTasks.swift
//  enRoute
//
//  Created by Apurva Kumari on 5/12/18.
//  Copyright © 2018 Apurva Kumari. All rights reserved.
//

import Foundation
import CoreLocation

class MapRouteTasks: NSObject {
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: NSDictionary!
    var overviewPolyline: NSDictionary!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    var destinationAddress: String!
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    override init() {
        super.init()
    }
    
    
    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        if let originLocation = origin {
            if let destinationLocation = destination {
                let encodedOriginString = originLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let encodedDestinationString = destinationLocation.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let waypointString = waypoints.joined(separator: "|")
                
                var encodedDirectionsURLString = baseURLDirections
                    + "origin=" + encodedOriginString!
                    + "&destination=" + encodedDestinationString!
                if(!waypointString.isEmpty) {
                    let encodedWaypointString = waypointString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    encodedDirectionsURLString += "&waypoints=" + encodedWaypointString!
                }
                
                let directionsURL = URL(string: encodedDirectionsURLString)
                
                DispatchQueue.main.async( execute: { () -> Void in
                    do{
                        let directionsData = try Data(contentsOf: directionsURL! as URL)
                        let dictionary = try JSONSerialization.jsonObject(with: directionsData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                        
                        let status =  dictionary["status"] as! String
                        
                        if status == "OK" {
                            self.selectedRoute = (dictionary["routes"] as! Array<NSDictionary>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as! NSDictionary
                            
                            let legs = self.selectedRoute["legs"] as! Array<NSDictionary>
                            
                            let startLocationDictionary = legs[0]["start_location"] as! NSDictionary
                            self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! NSDictionary;                            self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                            
                            self.originAddress = legs[0]["start_address"] as! String
                            self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
                            
                            self.calculateTotalDistanceAndDuration()
                            
                            completionHandler(status, true)
                        }
                        else {
                            completionHandler(status, false)
                        }
                        //}
                    } catch let error as NSError {
                        completionHandler(error.localizedDescription, false)
                    }
                    } as @convention(block) () -> Void)
            }
            else {
                completionHandler( "Destination is nil.",false)
            }
        }
        else {
            completionHandler("Origin is nil",false)
        }
    }
    
    func calculateTotalDistanceAndDuration() {
        let legs = self.selectedRoute["legs"] as! Array<NSDictionary>
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! NSDictionary)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! NSDictionary)["value"] as! UInt
        }
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(distanceInKilometers) Km"
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
    }
    
    func reRoute(){
        
    }
}
