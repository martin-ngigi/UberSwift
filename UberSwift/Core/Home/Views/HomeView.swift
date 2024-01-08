//
//  HomeView.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showLocationSearchView = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
            if showLocationSearchView {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            }
            else {
                LocationActivationSearchView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.bouncy()){
                            showLocationSearchView.toggle()
                        }
                    }
            }
            
            MapViewActionButton(showLocationSearchView: $showLocationSearchView)
                .padding(.leading)
                .padding(.top, 4)
        }
        
        
    }
}

#Preview {
    HomeView()
}
