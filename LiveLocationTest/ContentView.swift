//
//  ContentView.swift
//  KanbanDemo
//
//  Created by Hardik Darji on 14/07/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var vm = LocationViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(vm.locations) { record in
                    VStack(alignment: .leading) {
                        Text("Lat: \(record.latitude), Lng: \(record.longitude)")
                        Text("Time: \(record.timestamp.formatted())")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    Button("Start") { vm.startLiveUpdates() }
                        .padding()
                    Button("Stop") { vm.stopLiveUpdates() }
                        .padding()
                    Button("Clear") {
                        LocationStorage.shared.clear()
                        vm.loadStored()
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Live Locations")

            .onAppear {
                vm.requestPermission()
//                vm.startLiveUpdates() // <-- resume on relaunch
            }
        }
    }
}
