//
//  ScannedImagesManager.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 20/11/23.
//
/*
import Foundation

class ScannedImagesManager: ObservableObject {
    @Published var scannedImages: [ScannedImage] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }

    func getArchiveURL() -> URL {
        let plistName = "scannedImages.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }

    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedScannedImages = try? propertyListEncoder.encode(scannedImages)
        try? encodedScannedImages?.write(to: archiveURL, options: .noFileProtection)
    }

    func load() {
        let archiveURL = getArchiveURL()
        print(archiveURL)
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedScannedImageData = try? Data(contentsOf: archiveURL),
            let scannedImagesDecoded = try? propertyListDecoder.decode([ScannedImage].self, from: retrievedScannedImageData) {
            scannedImages = scannedImagesDecoded
        }
    }
}
 */
