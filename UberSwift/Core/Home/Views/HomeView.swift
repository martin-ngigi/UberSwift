//
//  HomeView.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    /**
     mapstate is more feasible/ideal compared to boolean property. i.e. incase of a boolean sceanario where we have 5 booleans , and one changes to true, we would be forced to change others to false.
     */
    @State private var mapState = MapViewState.noInput
    
    var body: some View {
        ZStack (alignment: .bottom) {
            ZStack(alignment: .top) {
                
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                }
                else  if mapState == .noInput {
                    LocationActivationSearchView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.bouncy()){
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            // Show RideRequestView only if user has selected the location
            if mapState == .locationSelected {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        
        
    }
}

#Preview {
    HomeView()
}
