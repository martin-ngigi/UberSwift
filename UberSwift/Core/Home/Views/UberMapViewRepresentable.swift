//
//  UberMapRepresentables.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import Foundation
import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable{
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var locationSearchViewModel : LocationSearchViewModel // check App/UberSwiftApp.swift
    
    /**
     Responsible for making the map view
     **/
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let coordinate = locationSearchViewModel.selectedLocationCoordinate{
            print("DEBUG: UberMapViewRepresentable->updateUIView. Selected coordinates in mapview is \(coordinate)")
            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
            context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable{
    /**
     MapCoordinator is like a link between the UIKit and SwiftUi. Since UIkit doesn't have all the functionalites to support the maps.
     **/
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        
        // MARK: - Lifecycle
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        /** 
         Responsible for zoom area we want to view when user allows app to access the location.
         **/
        // MARK: MKMapViewDelegate
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        /**
         Used to tell the mapview to draw the overlay with the select route that we have.
         */
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyine = MKPolylineRenderer(overlay: overlay)
            polyine.strokeColor = .systemBlue
            polyine.lineWidth = 6
            return polyine
        }
        
        // MARK: Helpers
        /**
         For adding map annotations i.e. map icon
         */
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)// remove previous annotations. i.e. if one had search previous, there is the previous icon which is not necessary.
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true) // move the map to where one has searched
        }
        
        /**
         Add polylines to the maps
         */
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            getDestinationRoute(from: userLocationCoordinate,
                                to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
            }
        }
        
        /**
         For generating routes from the map
         */
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                                 to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void){
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destPlacemark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else { return }
                completion(route)
            }
            
//            let request = MKDirections.Request()
//            request.source = MKMapItem.forCurrentLocation()
//            let destPlacemark = MKPlacemark(coordinate: destination)
//            request.destination = MKMapItem(placemark: destPlacemark)
//            request.requestsAlternateRoutes = false
//
//            let directions = MKDirections(request: request)
//            
//            directions.calculate(completionHandler: {(response, error) in
//                print ("RESPONSE: \(response)")
//                if error != nil {
//                    print("Failed getting directions with Error \(error?.localizedDescription)")
//                } else {
//                    if let route = response?.routes.first {
//                        completion(route)
//                    } else {
//                        print("No routes found")
//                    }
//                }
//            })
            
        }
    }
}
