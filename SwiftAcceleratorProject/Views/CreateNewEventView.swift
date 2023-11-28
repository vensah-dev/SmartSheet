import SwiftUI

struct CreateNewEventView: View {
    @ObservedObject var dataManager: DataManager
    @Binding var Events: [Event]
    @State var title = ""
    @State var description = ""
    @State var EventStartDate: Date = Date.now
    @State var EventEndDate: Date = Date.now + 3600
    
    @State var Edit: Bool
    
    @State var DisableCreate = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                        in: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundStyle(Color.accentColor)
                    .tint(Color.accentColor)

                    DatePicker(
                        "End Date",
                        selection: $EventEndDate,
                        in: EventStartDate..., // Allow selection starting from the selected start date
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundStyle(Color.accentColor)
                    .tint(Color.accentColor)
                }
            }
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if validateInputs() {
                            Events.append(Event(title: title, details: description, startDate: EventStartDate, endDate: EventEndDate))
                            dismiss()
                        } else {
                            showAlert = true
                        }
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Validation Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func Validate() {
        if (!title.trimmingCharacters(in: .whitespaces).isEmpty) {
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
    
    func validateInputs() -> Bool {
        if !title.trimmingCharacters(in: .whitespaces).isEmpty {
            if EventEndDate >= EventStartDate {
                let startTime = Calendar.current.component(.hour, from: EventStartDate) * 60 + Calendar.current.component(.minute, from: EventStartDate)
                let endTime = Calendar.current.component(.hour, from: EventEndDate) * 60 + Calendar.current.component(.minute, from: EventEndDate)

                if startTime < endTime {
                    if Events.contains(where: { $0.title == title }) {
                        alertMessage = "An event with the same title already exists."
                        return false
                    } else {
                        return true
                    }
                } else {
                    alertMessage = "End time must be after start time."
                    return false
                }
            } else {
                alertMessage = "End date must be after or equal to start date."
                return false
            }
        } else {
            alertMessage = "Title cannot be empty."
            return false
        }
    }
}
