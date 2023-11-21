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
                                destination: ImageDetail(image: scannedImages[index].image, title: $scannedImages[index].title, caption: $scannedImages[index].caption),
                                label: {
                                    HStack {
                                        Image(uiImage: scannedImages[index].image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(5)
                                        
                                        VStack(alignment: .leading) {
                                            Text(scannedImages[index].title)
                                            if !scannedImages[index].caption.isEmpty {
                                                Text(scannedImages[index].caption)
                                                    .font(.caption)
                                            }
                                        }
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
            .navigationTitle("Resources")
            .navigationBarItems(trailing: NavigationLink(
                destination: WorksheetDetailView(scannedImages: $scannedImages),
                label: {
                    Image(systemName: "plus.circle")
                }
            ))
        }
    }
    
    func delete(at offsets: IndexSet) {
        scannedImages.remove(atOffsets: offsets)
    }
}

struct ImageDetail: View {
    @State var image: UIImage
    @Binding var title: String
    @Binding var caption: String
    
    var body: some View {
        VStack {
            TextField("", text: $title)
                .font(.title)
                .padding()
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .navigationBarTitle("", displayMode: .inline)
            
        }
    }
}

#Preview {
    FilesView()
}
