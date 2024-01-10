//
//  MapViewActionButton.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        Button{
            withAnimation(.bouncy()){
                // clear the map and recenter to original loaction
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundStyle(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func actionForState(_ state: MapViewState){
        switch state {
            case .noInput:
                print("DEBUG: No input")
            case .searchingForLocation:
                mapState = .noInput
            case .locationSelected:
                //print("DEBUG: Clear map view")
                mapState = .noInput
                viewModel.selectedLocationCoordinate = nil
            
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation , .locationSelected:
            return "arrow.left"
        }
    }
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
}
