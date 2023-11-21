import SwiftUI

struct WorksheetDetailView: View {
    @State private var title = ""
    @State private var subtitle = ""
    @State private var practicePaper = false
    @Environment(\.dismiss) var dismiss
    @State private var showScannerSheet = false
    @Binding var scannedImages: [ScannedImage]

    var body: some View {
        List {
            Section(header: Text("Worksheet Details")) {
                TextField("Enter a title", text: $title)
                TextField("Enter a subtitle", text: $subtitle)
            }

            Section(header: Text("Additional Details")) {
                NavigationLink(destination: SubjectView()) {
                    HStack {
                        Text("Subject")
                        Spacer()
                        Text("Select")
                            .foregroundStyle(.gray)
                    }
                }

                NavigationLink(destination: TopicView()) {
                    HStack {
                        Text("Topic")
                        Spacer()
                        Text("Select")
                            .foregroundStyle(.gray)
                    }
                }

                Toggle("Practice Paper", isOn: $practicePaper)
            }

            Section {
                Button {
                    showScannerSheet = true
                } label: {
                    Text("Scan worksheet")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("New Worksheet")
        .sheet(isPresented: $showScannerSheet, content: {
            ScannerView { scannedImage in
                if let images = scannedImage {
                    for image in images {
                        let newScannedImage = ScannedImage(title: self.title, caption: self.subtitle, image: image)
                        self.scannedImages.append(newScannedImage)
                        dismiss()
                    }
                }
                self.showScannerSheet = false
            }
        })
    }
}
