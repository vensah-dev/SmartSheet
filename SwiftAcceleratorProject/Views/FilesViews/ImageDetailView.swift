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
    @Binding var title: String
    @Binding var caption: String
    @Binding var durationHours: Int?
    @Binding var durationMinutes: Int?
    @Binding var lockAfterDuration: Bool?
    
    var body: some View {
        NavigationLink(destination: ImageDetailView(images: image, currentIndex: index)) {
            Image(uiImage: image[0])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
                .cornerRadius(20)
                .padding(.horizontal, 10)
        }
        .navigationTitle(title)

        Spacer()
    }
}

struct ImageDetailView: View {
    var images: [UIImage]
    var currentIndex: Int
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .padding(.horizontal, 10)
                }
            }
            .padding(.vertical, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
