//
//  LocationViewModel.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject{
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Properties
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            // Query fragment is the destination address that user types, has onTap listener that listens to keyboard as user keeps on keying in.
            print("DEBUG: Query fragment is \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    // MARK: Lifecycle
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: Helpers
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            
            if let error = error {
                print("DEBUG: Location serach failed with error \(error.localizedDescription)")
                return
            }
            
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate
            
            print("DEBUG: Location coordinate \(coordinate)")
        }

    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double{
        guard let destCoordinate = selectedLocationCoordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
                
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
                let tripDistanceInMeters = userLocation.distance(from: destination)
                return type.computePrice(for: tripDistanceInMeters)
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    /**get results from autocomplete**/
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
