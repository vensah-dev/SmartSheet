import SwiftUI

struct FilesView: View {
    @StateObject public var dataManager = DataManager()
    @State private var selectedSubjectIndex = 0
    @State var uniqueSubjects: [String] = []
    @State private var uniqueTopics: [String] = []
    @State private var sectionStates: [Bool] = []
    @State var showWorksheetView = false

    
    var body: some View {
        NavigationView {
            List {
                if dataManager.scannedImages.isEmpty {
                    Text("No files yet")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(uniqueTopics.indices, id: \.self) { index in
                        let topic = uniqueTopics[index]
                        Section(isExpanded: $sectionStates[index],
                                content: {
                            if sectionStates[index] {
                                ForEach(dataManager.scannedImages.indices, id: \.self) { imageIndex in
                                    let images = dataManager.scannedImages[imageIndex].image
                                    let subject = dataManager.scannedImages[imageIndex].subject
                                    let currentTopic = dataManager.scannedImages[imageIndex].topic
                                    if selectedSubjectIndex == -1 || subject == dataManager.scannedImages[selectedSubjectIndex].subject, currentTopic == topic {
                                        NavigationLink(
                                            destination: ImageDetail(
                                                index: imageIndex,
                                                image: images,
                                                dataManager: dataManager
                                            )
                                        ) {
                                            HStack {
                                                Image(uiImage: dataManager.scannedImages[imageIndex].image.first ?? UIImage())
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(5)
                                                
                                                VStack(alignment: .leading) {
                                                    Text(dataManager.scannedImages[imageIndex].title)
                                                        .foregroundColor(Color.accentColor)
                                                        .font(.headline)
                                                    
                                                    if !dataManager.scannedImages[imageIndex].caption.isEmpty {
                                                        Text(dataManager.scannedImages[imageIndex].caption)
                                                            .font(.caption)
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: { indices in
                                    delete(at: indices)
                                })
                            }
                        },
                                header:{Text(topic)}
                        )
                        .textCase(nil)
                    }
                }
            }
            .onChange(of: dataManager.scannedImages){
                uniqueSubjects = Array(Set(dataManager.scannedImages.map { $0.subject }))

                uniqueTopics = Array(Set(dataManager.scannedImages.map { $0.topic }))
                sectionStates = Array(repeating: true, count: uniqueTopics.count)
            }
            .onAppear(){
                uniqueSubjects = Array(Set(dataManager.scannedImages.map { $0.subject }))

                uniqueTopics = Array(Set(dataManager.scannedImages.map { $0.topic }))
                sectionStates = Array(repeating: true, count: uniqueTopics.count)
            }
            .listStyle(.sidebar)
            .navigationBarTitle("Files")
            .navigationBarItems(leading: EditButton(), trailing:
                                    HStack {
                Picker("Subject", selection: $selectedSubjectIndex) {
                    Text("All").tag(-1)
                    ForEach(uniqueSubjects.indices, id: \.self) { index in
                        Text(uniqueSubjects[index])
                            .tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Button{
                    showWorksheetView.toggle()
                }label:{
                    Image(systemName: "plus.circle")
                }
                .fullScreenCover(isPresented: $showWorksheetView){
                    WorksheetDetailView(scannedImages: $dataManager.scannedImages, dataManager: dataManager)
                }
            })
        }
    }
    
    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}
