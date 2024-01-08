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
        if let selectedLocation = locationSearchViewModel.selectedLocation{
            print("DEBUG: UberMapViewRepresentable->updateUIView. Selected location in mapview is \(selectedLocation)")
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
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        /** 
         Responsible for zoom area we want to view when user allows app to access the location.
         **/
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            parent.mapView.setRegion(region, animated: true)
        }
    }
}
