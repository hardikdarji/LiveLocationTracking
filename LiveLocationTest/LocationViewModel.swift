//
//  LocationViewModel.swift
//  KanbanDemo
//
//  Created by Hardik Darji on 14/07/25.
//


import Foundation
import CoreLocation

import SwiftUI

@MainActor
class LocationViewModel: ObservableObject {
    @Published var locations: [LocationRecord] = []
    @Published var isStationary: Bool = false
    private var backgroundActivity: CLBackgroundActivitySession?

    private var updateTask: Task<Void, Never>?
    private var updates = CLLocationUpdate.liveUpdates(.automotiveNavigation)

    init() {
        loadStored()
    }

    func requestPermission() {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()

        // add delay 'Always' request slightly after 'WhenInUse'
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            manager.requestAlwaysAuthorization()
        }
    }


    func loadStored() {
        locations = LocationStorage.shared.fetch()
    }

    func startLiveUpdates() {
        updateTask?.cancel()
        backgroundActivity = CLBackgroundActivitySession() // 👈 This keeps your app alive in background

        updateTask = Task {
            do {
                for try await update in updates {
                    if let loc = update.location {
                        let record = LocationRecord(
                            latitude: loc.coordinate.latitude,
                            longitude: loc.coordinate.longitude,
                            timestamp: Date()
                        )
                        
                        LocationStorage.shared.save(record)
                        loadStored()
                    }
                    // To stop updates break out of the for loop
                    self.isStationary = update.stationary
                    print("🛑 Stationary: \(isStationary)")
                }
            } catch {
                print("Error in liveUpdates: \(error)")
            }
        }
    }

    func stopLiveUpdates() {
        updateTask?.cancel()
        updateTask = nil
        backgroundActivity = nil // 👈 End background session

    }
}
