import Foundation
import UIKit
import Combine

class DataManager: ObservableObject {
    @Published var events: [Event] = [] {
        didSet {
            saveEvents()
        }
    }

    @Published var scannedImages: [ScannedImage] = [] {
        didSet {
            saveScannedImages()
        }
    }

    init() {
        loadEvents()
        loadScannedImages()
    }

    // MARK: - Events Persistence

    func getEventsArchiveURL() -> URL {
        let plistName = "events.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName)
    }

    func saveEvents() {
        let archiveURL = getEventsArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedEvents = try? propertyListEncoder.encode(events)
        try? encodedEvents?.write(to: archiveURL, options: .noFileProtection)
    }

    func loadEvents() {
        let archiveURL = getEventsArchiveURL()
        let propertyListDecoder = PropertyListDecoder()

        if let retrievedEventData = try? Data(contentsOf: archiveURL),
            let eventsDecoded = try? propertyListDecoder.decode([Event].self, from: retrievedEventData) {
            events = eventsDecoded
        }
    }

    // MARK: - ScannedImages Persistence

    func getScannedImagesArchiveURL() -> URL {
        let plistName = "scannedImages.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName)
    }

    func saveScannedImages() {
        let archiveURL = getScannedImagesArchiveURL()
        let propertyListEncoder = PropertyListEncoder()

        // Convert UIImage instances to Data before saving
        let scannedImagesWithImageData: [ScannedImageWithImageData] = scannedImages.map { scannedImage in
            let imageDataArray: [Data] = scannedImage.image.compactMap { image in
                return image.pngData()
            }
            return ScannedImageWithImageData(
                title: scannedImage.title,
                caption: scannedImage.caption,
                image: imageDataArray,
                durationHours: scannedImage.durationHours,
                durationMinutes: scannedImage.durationMinutes,
                lockAfterDuration: scannedImage.lockAfterDuration
            )
        }

        let encodedScannedImages = try? propertyListEncoder.encode(scannedImagesWithImageData)
        try? encodedScannedImages?.write(to: archiveURL, options: .noFileProtection)
    }

    func loadScannedImages() {
        let archiveURL = getScannedImagesArchiveURL()
        let propertyListDecoder = PropertyListDecoder()

        if let retrievedImageData = try? Data(contentsOf: archiveURL),
            let scannedImagesWithImageData = try? propertyListDecoder.decode([ScannedImageWithImageData].self, from: retrievedImageData) {

            // Convert Data back to UIImage after loading
            scannedImages = scannedImagesWithImageData.map { scannedImageWithImageData in
                let uiImageArray: [UIImage] = scannedImageWithImageData.image.map { imageData in
                    return UIImage(data: imageData) ?? UIImage()
                }

                return ScannedImage(
                    title: scannedImageWithImageData.title,
                    caption: scannedImageWithImageData.caption,
                    image: uiImageArray,
                    durationHours: scannedImageWithImageData.durationHours,
                    durationMinutes: scannedImageWithImageData.durationMinutes,
                    lockAfterDuration: scannedImageWithImageData.lockAfterDuration
                )
            }
        }
    }
}

// Helper struct to store UIImage data during encoding
struct ScannedImageWithImageData: Codable {
    var title: String
    var caption: String
    var image: [Data]
    var durationHours: Int?
    var durationMinutes: Int?
    var lockAfterDuration: Bool?
}
