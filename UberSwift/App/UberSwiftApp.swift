//
//  UberSwiftApp.swift
//  UberSwift
//
//  Created by Martin Wainaina on 08/01/2024.
//

import SwiftUI

@main
struct UberSwiftApp: App {
    /**
     locationViewModel is an environment object. It is only created once and used in many places. This will help us avoid creating many instances of viewmodels which will be totally different objects.
     */
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
