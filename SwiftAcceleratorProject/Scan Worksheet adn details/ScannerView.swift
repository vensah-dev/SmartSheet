//
//  ScannerView.swift
//  Our Titled Project
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import VisionKit
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: ([UIImage]?) -> Void

    init(completion: @escaping ([UIImage]?) -> Void) {
        self.completionHandler = completion
    }

    typealias UIViewControllerType = VNDocumentCameraViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }

    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: ([UIImage]?) -> Void

        init(completion: @escaping ([UIImage]?) -> Void) {
            self.completionHandler = completion
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = (0..<scan.pageCount).map { pageIndex in
                scan.imageOfPage(at: pageIndex)
            }
            completionHandler(images)
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller finished with error ", error)
            completionHandler(nil)
        }
    }
}
