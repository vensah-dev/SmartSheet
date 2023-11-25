//
//  ImageView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 21/11/23.
//

import SwiftUI

struct ImageDetail: View {
    @State var index: Int = 0
    @State var image: [UIImage]
    @StateObject var dataManager: DataManager

    var body: some View {
        var scannedImage = dataManager.scannedImages[index]
        NavigationLink(destination: ImageDetailView(images: image, currentIndex: index, dataManager: dataManager)) {
            VStack {
                Image(uiImage: image.first ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .cornerRadius(20)
                    .padding(10)
            }
        }
        .navigationTitle(scannedImage.title)
        
        Spacer()
        
        Text(scannedImage.subject)
    }
}

struct ImageDetailView: View {
    var images: [UIImage]
    var currentIndex: Int
    @StateObject var dataManager: DataManager
    @State private var loadedImages: [UIImage] = []

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20) {
                ForEach(loadedImages.indices, id: \.self) { index in
                    Image(uiImage: loadedImages[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.global().async {
                loadedImages = images
            }
        }
        .onDisappear {
            dataManager.saveEvents()
            dataManager.saveScannedImages()
        }
    }
}
