import SwiftUI

struct CreateNewEventView: View {
    @Binding var Events: [Event]
    @State var title = ""
    @State var description = ""
    @State var EventStartDate: Date = Date.now
    @State var EventEndDate: Date = Date.now
    
    @State var Edit: Bool
    
    @State var showAlert = false
    @State var alertMSG = "Fill up all details!"
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Date")) {
                    DatePicker(
                        "Start Date",
                        selection: $EventStartDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    .foregroundStyle(Color.accentColor)
                    .tint(Color.accentColor)
                    
                    DatePicker(
                        "End Date",
                        selection: $EventEndDate,
                        in: EventStartDate...,
                        displayedComponents: [.date]
                    )
                    .foregroundStyle(Color.accentColor)
                }
            }
            .toolbar(){
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if(title != ""){
                            let currentDate = Date()
                            if EventStartDate < currentDate || EventEndDate < currentDate {
                                alertMSG = "Please select a future date and time!"
                                showAlert = true
                            } else {
                                var eventExists = false
                                for x in Events {
                                    if title == x.title {
                                        eventExists = true
                                        break
                                    }
                                }
                                
                                if eventExists {
                                    alertMSG = "Event already exists!"
                                    showAlert = true
                                } else {
                                    Events.append(Event(title: title, details: description, startDate: EventStartDate, endDate: EventEndDate))
                                    dismiss()
                                }
                            }
                        } else {
                            alertMSG = "Enter a title!"
                            showAlert = true
                        }
                    } label: {
                        Text("Save")
                            .foregroundStyle(Color.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                }
            }
            .opacity(0.8)
            .navigationTitle("Create New Event")
            .navigationBarTitleDisplayMode(.inline)
            .alert(alertMSG, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
