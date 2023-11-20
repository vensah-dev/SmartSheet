//
//  FilesView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI
import VisionKit

struct FilesView: View {
    @State private var showScannerSheet = false
    @State public var scannedImagesArray: [UIImage] = []
    @State public var scannedImages: [ScannedImage] = []

    var body: some View {
        NavigationView {
            VStack {
                if scannedImages.isEmpty {
                    Text("No scan yet")
                } else {
                    List {
                        ForEach(0..<scannedImages.count, id: \.self) { index in
                            NavigationLink(
                                destination: ImageDetail(image: scannedImages[index].image, title: "Image \(index + 1)"),
                                label: {
                                    HStack {
                                        Image(uiImage: scannedImages[index].image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 80)

                                        Text("Image \(index + 1)")
                                    }
                                })
                        }
                        .onDelete(perform: delete)
                    }
                    .toolbar {
                        EditButton()
                    }
                }
            }
            .navigationTitle("Scanned Images")
            .navigationBarItems(trailing: Button(action: {
                self.showScannerSheet = true
            }, label: {
                Image(systemName: "camera.viewfinder")
                    .font(.title)
            })
            .sheet(isPresented: $showScannerSheet, content: {
                ScannerView { scannedImage in
                    if let images = scannedImage {
                        self.scannedImagesArray.append(contentsOf: images)
                    }
                    for image in scannedImagesArray{
                        let scan = ScannedImage(title: "Default Title", caption: "Default Caption", image: image)
                        self.scannedImages.append(scan)
                    }
                    self.showScannerSheet = false
                }
            }))
        }
    }
    
    func delete(at offsets: IndexSet) {
        scannedImages.remove(atOffsets: offsets)
    }
}


struct ImageDetail: View {
    var image: UIImage
    var title: String

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .navigationBarTitle("", displayMode: .inline)

            Text(title)
                .font(.title)
                .padding()
        }
    }
}

#Preview {
    FilesView()
}
