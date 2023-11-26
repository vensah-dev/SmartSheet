import SwiftUI

struct FilesView: View {
    @StateObject var dataManager = DataManager()
    @State var searchText = ""
    @State private var selectedSubjectIndex = -1
    @State var filterSubject: String = ""
    @State var uniqueSubjects: [String] = []
    @State private var uniqueTopics: [String] = []
    @State private var sectionStates: [Bool] = []
    @State var showWorksheetView = false
    
    var body: some View {
        NavigationView {
            List {
                HStack(spacing: 0){
                    Button{
                        selectedSubjectIndex = -1
                    }label:{
                        let selected: Bool = selectedSubjectIndex == -1
                        
                        Text("All")
                            .foregroundColor(selected ? .white : Color.accentColor)
                            .padding(.init(top: 8, leading: 15, bottom: 8, trailing: 15))
                            .background(selected ? Color.accentColor : Color.accentColor.opacity(0.0))
                            .cornerRadius(10)
                            .bold(selected)
                    }
                    
                    Divider()
                        .padding(.init(top: 5, leading: 15, bottom: 5, trailing: 0))
                    
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(uniqueSubjects.indices, id: \.self){ i in
                                Button{
                                    selectedSubjectIndex = i
                                }label:{
                                    let selected: Bool = selectedSubjectIndex == i
                                    
                                    Text(uniqueSubjects[i])
                                        .foregroundColor(selected ? .white : Color.accentColor)
                                        .padding(.init(top: 8, leading: 15, bottom: 8, trailing: 15))
                                        .background(selected ? Color.accentColor : Color.accentColor.opacity(0.0))
                                        .cornerRadius(10)
                                        .bold(selected)
                                }
                                .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .listRowBackground(Color.red.opacity(0.0))
                
                if dataManager.scannedImages.isEmpty {
                    Text("No files yet")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .listRowBackground(Color.red.opacity(0.0))
                    
                }
                
                ForEach(uniqueTopics.indices, id: \.self) { index in
                    let topic = uniqueTopics[index]
                    Section(isExpanded: $sectionStates[index],
                            content: {
                        if sectionStates[index] {
                            
                            ForEach(displayFiles, id: \.id) { img in
                                let images = img.image
                                let subject = img.subject
                                let currentTopic = img.topic
                                if selectedSubjectIndex == -1 || subject == uniqueSubjects[selectedSubjectIndex], currentTopic == topic {
                                    NavigationLink(
                                        destination: ImageDetail(
                                            title: img.title,
                                            image: images,
                                            dataManager: dataManager
                                        )
                                    ) {
                                        HStack {
                                            Image(uiImage: img.image.first ?? UIImage())
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(5)
                                            
                                            VStack(alignment: .leading) {
                                                Text(img.title)
                                                    .foregroundColor(Color.accentColor)
                                                    .font(.headline)
                                                
                                                if !img.caption.isEmpty {
                                                    Text(img.caption)
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
                                    Button{
                showWorksheetView.toggle()
            }label:{
                Image(systemName: "plus.circle")
            }
                .fullScreenCover(isPresented: $showWorksheetView){
                    WorksheetDetailView(scannedImages: $dataManager.scannedImages, dataManager: dataManager)
                }
            )
        }
    }
    
    var displayFiles: [ScannedImage]{
        if(searchText.isEmpty){
            return dataManager.scannedImages
        }
        else{
            return dataManager.scannedImages.filter{ $0.title.contains(searchText)}
        }
    }
    
    func delete(at offsets: IndexSet) {
        dataManager.scannedImages.remove(atOffsets: offsets)
        dataManager.saveScannedImages()
    }
}
