//
//  ScannedImage.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import Foundation
import UIKit
import SwiftUI
import Swift

//Events
struct Event: Identifiable, Encodable, Decodable {
    var id = UUID()
    var title: String
    var details: String
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    
}

//Files
struct ScannedImage: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var caption: String
    var image: [UIImage]
    var durationHours: Int?
    var durationMinutes: Int?
    var lockAfterDuration: Bool?
    var subject: String
    var topic: String
    var used: Int = 0
    
    static func == (lhs: ScannedImage, rhs: ScannedImage) -> Bool {
        return lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.caption == rhs.caption
        && lhs.image == rhs.image
        && lhs.durationHours == rhs.durationHours
        && lhs.durationMinutes == rhs.durationMinutes
        && lhs.lockAfterDuration == rhs.lockAfterDuration
        && lhs.subject == rhs.subject
        && lhs.topic == rhs.topic
    }
}

//StatView
struct Test: Identifiable {
    var id = UUID()
    var title: String
}
