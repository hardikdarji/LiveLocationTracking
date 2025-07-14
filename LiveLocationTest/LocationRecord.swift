//
//  LocationRecord.swift
//  KanbanDemo
//
//  Created by Hardik Darji on 14/07/25.
//

import Foundation
struct LocationRecord: Identifiable, Codable {
    var id = UUID()
    let latitude: Double
    let longitude: Double
    let timestamp: Date
}
