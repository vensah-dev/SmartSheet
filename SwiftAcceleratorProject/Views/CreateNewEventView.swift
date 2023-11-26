import SwiftUI

struct CreateNewEventView: View {
    @ObservedObject var dataManager = DataManager()
    @Binding var Events: [Event]
    @State var title = ""
    @State var description = ""
    @State var EventStartDate: Date = Date.now
    @State var EventEndDate: Date = Date.now
    
    @State var Edit: Bool
    
    @State var DisableCreate = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title, onCommit: Validate)
                        .disableAutocorrection(true)
                    TextField("Description", text: $description)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Date")) {
                    DatePicker(
                        "Start Date",
                        selection: $EventStartDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundStyle(Color.accentColor)
                    .tint(Color.accentColor)
                    
                    DatePicker(
                        "End Date",
                        selection: $EventEndDate,
                        in: EventStartDate...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundStyle(Color.accentColor)
                    .tint(Color.accentColor)
                }
            }
            .toolbar(){
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Events.append(Event(title: title, details: description, startDate: EventStartDate, endDate: EventEndDate))
                        dismiss()
                    } label: {
                        Text("Save")
                            .foregroundStyle(Color.accentColor)
                    }
                    .onAppear(perform: Validate)
                    .onChange(of: EventStartDate){
                        Validate()
                    }
                    .onChange(of: EventEndDate){
                        Validate()
                    }
                    .foregroundStyle(Color.accentColor)
                    .disabled(DisableCreate)
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
        }
    }
    
    func Validate(){
        if(!title.trimmingCharacters(in: .whitespaces).isEmpty){
            if (EventEndDate >= EventStartDate) {
                DisableCreate = false
            } else {
                var eventExists = false
                for x in Events {
                    if title == x.title {
                        eventExists = true
                        break
                    }
                }
                
                if eventExists {
                    DisableCreate = true
                } else {
                    DisableCreate = false
                }
            }
        } else {
            DisableCreate = true
        }
    }
}
