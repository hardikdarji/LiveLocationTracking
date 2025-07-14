//
//  LocationStorage.swift
//  KanbanDemo
//
//  Created by Hardik Darji on 14/07/25.
//


import Foundation

class LocationStorage {
    static let shared = LocationStorage()
    private let key = "storedLocations"

    func save(_ record: LocationRecord) {
        var existing = fetch()
        existing.insert(record, at: 0)
        if let data = try? JSONEncoder().encode(existing) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func fetch() -> [LocationRecord] {
        if let data = UserDefaults.standard.data(forKey: key),
           let records = try? JSONDecoder().decode([LocationRecord].self, from: data) {
            return records
        }
        return []
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
