//
//  EventDetailView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 22/11/2023.
//

import SwiftUI

struct EventDetailView: View {
    @ObservedObject var dataManager: DataManager
    @State var event: Event
    @Binding var Events: [Event]
    @State var index = 0
    @State var isEditing = false
    @State private var showAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section(header: Text("Date")) {
                DatePicker(
                    "Start Date",
                    selection: $event.startDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .foregroundColor(Color.accentColor)
                .tint(Color.accentColor)
                .disabled(!isEditing)
                
                DatePicker(
                    "End Date",
                    selection: $event.endDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .foregroundColor(Color.accentColor)
                .tint(Color.accentColor)
                .disabled(!isEditing)
            }
            
            Section(header: Text("Description")) {
                TextField("Enter a description", text: $event.details)
                    .disabled(!isEditing)
            }
        }
        .opacity(0.8)
        .navigationTitle($event.title)
        .navigationBarTitleDisplayMode(isEditing ? .inline : .large)
        .navigationBarItems(trailing: editButton)
        .onAppear {
            var i = 0
            
            for x in Events {
                if x.title == event.title {
                    break
                }
                
                i += 1
            }
            
            index = i
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Validation Error"), message: Text("Start date and time must be less than end date and time."), dismissButton: .default(Text("OK")))
        }
    }
    
    private var editButton: some View {
        Button(action: {
            if validateDateAndTime() {
                if !isEditing {
                    Events[index].sentNotification = false
                    dataManager.saveEvents()
                }
                withAnimation {
                    isEditing.toggle()
                    Events[index] = event // Update the Events array
                    dataManager.saveEvents() // Save changes
                }
            } else {
                showAlert.toggle()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
    
    private func validateDateAndTime() -> Bool {
        return event.startDate < event.endDate
    }
}
