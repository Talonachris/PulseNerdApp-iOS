//
//  PulseFlashApp.swift
//  PulseFlash
//
//  Created by Christian Hagenacker on 12.07.25.
//

import SwiftUI

@main
struct PulseFlashApp: App {
    init() {
        AppearanceConfigurator.configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
