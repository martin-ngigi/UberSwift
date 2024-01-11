//
//  RideType.swift
//  UberSwift
//
//  Created by Martin Wainaina on 10/01/2024.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable{
    case uberX
    case black
    case uberXL
    
    var id: Int { return rawValue }
    
    var description: String {
        switch self {
        case .uberX:
            return "UberX"
        case .black:
            return "UberBlack"
        case .uberXL:
            return "UberXL"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX:
            return "uber-x"
        case .black:
            return "uber-black"
        case .uberXL:
            return "uber-x"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX:
            return 5
        case .black:
            return 10
        case .uberXL:
            return 20
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        var distanceInMiles = distanceInMeters / 1600
        switch self {
        case .uberX:
            return distanceInMiles * 1.5 + baseFare
        case .black:
            return distanceInMiles * 1.75 + baseFare
        case .uberXL:
            return distanceInMiles * 2.0 + baseFare
        }
    }
}
