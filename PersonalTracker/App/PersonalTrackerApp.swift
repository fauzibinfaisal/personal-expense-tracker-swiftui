//
//  PersonalTrackerApp.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import SwiftUI
import SwiftData

@main
struct PersonalTrackerApp: App {
    private let container = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            AppRootView(container: container)
        }
        .modelContainer(container.modelContainer)
    }
}
