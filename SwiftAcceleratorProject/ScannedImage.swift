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

struct ScannedImage: Identifiable {
    var id = UUID()
    var title: String
    var caption: String
    var image: UIImage
}
