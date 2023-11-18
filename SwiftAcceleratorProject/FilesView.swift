//
//  FilesView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct FolderView: View {
    @State private var showScannerSheet = false
    @State private var scannedImages: [UIImage] = []

    var body: some View {
        NavigationView {
            VStack {
                if scannedImages.isEmpty {
                    Text("No scan yet")
                } else {
                    List {
                        ForEach(0..<scannedImages.count, id: \.self) { index in
                            NavigationLink(
                                destination: ImageDetail(image: scannedImages[index], title: "Image \(index + 1)"),
                                label: {
                                    HStack {
                                        Image(uiImage: scannedImages[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 80)

                                        Text("Image \(index + 1)")
                                    }
                                })
                        }
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
                ScannerView { scannedImages in
                    if let images = scannedImages {
                        self.scannedImages.append(contentsOf: images)
                    }
                    self.showScannerSheet = false
                }
            }))
        }
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
    FolderView()
}
