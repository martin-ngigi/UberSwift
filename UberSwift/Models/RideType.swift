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
            return "uber-x"
        case .black:
            return "uber-black"
        case .uberXL:
            return "uber-x"
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
}
