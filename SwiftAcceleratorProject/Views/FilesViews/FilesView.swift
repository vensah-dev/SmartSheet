//
//  FilesView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI
import VisionKit

struct FilesView: View {
    @StateObject private var dataManager = DataManager()

    var body: some View {
        NavigationView {
            VStack {
                if dataManager.scannedImages.isEmpty {
                    Text("No resources yet")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    List {
                        ForEach(dataManager.scannedImages.indices, id: \.self) { index in
                            NavigationLink(
                                destination: ImageDetail(
                                    image: dataManager.scannedImages[index].image,
                                    title: $dataManager.scannedImages[index].title,
                                    caption: $dataManager.scannedImages[index].caption,
                                    durationHours: $dataManager.scannedImages[index].durationHours,
                                    durationMinutes: $dataManager.scannedImages[index].durationMinutes,
                                    lockAfterDuration: $dataManager.scannedImages[index].lockAfterDuration,
                                    dataManager: dataManager
                                )
                            ) {
                                HStack {
                                    Image(uiImage: dataManager.scannedImages[index].image[0])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(5)

                                    VStack(alignment: .leading) {
                                        Text(dataManager.scannedImages[index].title)
                                        if !dataManager.scannedImages[index].caption.isEmpty {
                                            Text(dataManager.scannedImages[index].caption)
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                        }
                    }
                }
            }
            .navigationTitle("Resources")
            .navigationBarItems(trailing: NavigationLink(
                destination: WorksheetDetailView(scannedImages: $dataManager.scannedImages, dataManager: dataManager),
                label: {
                    Image(systemName: "plus.circle")
                }
            ))
        }
    }

    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}


#Preview {
    FilesView()
}
