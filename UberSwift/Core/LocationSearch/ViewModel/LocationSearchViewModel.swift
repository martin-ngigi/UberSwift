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
    @Published var selectedLocation: String?
    
    // MARK: - Properties
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            print("DEBUG: Query fragment is \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: Lifecycle
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: Helpers
    
    func selectLocation(_ location: String){
        self.selectedLocation = location
        print("DEBUG: Selected location is \(self.selectedLocation)")
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    /**get results from autocomplete**/
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
