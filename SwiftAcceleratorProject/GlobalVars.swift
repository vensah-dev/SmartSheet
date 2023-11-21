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
    var date: Date = Date.now
}

//scannedImages
struct ScannedImage: Identifiable {
    var id = UUID()
    var title: String
    var caption: String
    var image: UIImage
}

//scannedImages
struct Test: Identifiable {
    var id = UUID()
    var title: String
}
