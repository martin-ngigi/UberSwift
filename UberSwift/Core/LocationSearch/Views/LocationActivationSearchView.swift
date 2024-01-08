//
//  LocationView.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import SwiftUI

struct LocationActivationSearchView: View {
    var body: some View {
        HStack{
            Rectangle()
                .fill(.black)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
                
            
            Text("Where to?")
                .foregroundStyle(Color(.darkGray))
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background( 
            Rectangle()
                .fill(.white)
                .cornerRadius(10)
                .shadow(color: .black, radius: 6)
                
        )
    }
}

#Preview {
    LocationActivationSearchView()
}
