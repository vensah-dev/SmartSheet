//
//  EventDetailView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 22/11/2023.
//

import SwiftUI

struct EventDetailView: View {
    @ObservedObject var dataManager = DataManager()
    @State var event: Event
    @Binding var Events: [Event]
    @State var index = 0
    @State var isEditing = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List{
            Section(header: Text("Date")){
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
            
            Section(header: Text("Description")){
                TextField("Enter a description", text: $event.details)
                    .disabled(!isEditing)
            }
        }
        .opacity(0.8)
        .navigationTitle($event.title)
        .navigationBarTitleDisplayMode(isEditing ? .inline : .large)
        
        .navigationBarItems(trailing: editButton)
        .onAppear{
            var i = 0
            
            for x in Events{
                if(x.title == event.title){
                    break
                }
                
                i += 1
            }
            
            index = i
        }
        .onDisappear{
            Events[index] = event
        }
    }
    private var editButton: some View {
        Button(action: {
            if(!isEditing){
                Events[index].sentNotification = false
                dataManager.saveEvents()
            }
            withAnimation {
                isEditing.toggle()
            }
        }) {
            Text(isEditing ? "Done" : "Edit")
        }
    }
}
