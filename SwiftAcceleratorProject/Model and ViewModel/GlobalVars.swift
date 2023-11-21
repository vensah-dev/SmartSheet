//
//  ScannedImage.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import Foundation
import UIKit

class ScannedImagesData: ObservableObject {
    @Published var scannedImages: [ScannedImage] = []
}

//Events
struct Event: Identifiable {
    var id = UUID()
    var title: String
    var details: String
    var startDate: Date = Date.now
    var endDate: Date = Date.now

}

//Files
struct ScannedImage: Identifiable {
    var id = UUID()
    var title: String
    var caption: String
    var image: [UIImage]
    var durationHours: Int?
    var durationMinutes: Int?
    var lockAfterDuration: Bool?
}

//Calendar
struct Test: Identifiable {
    var id = UUID()
    var title: String
}
