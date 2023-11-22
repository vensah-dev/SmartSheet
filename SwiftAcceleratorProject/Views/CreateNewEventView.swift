//
//  CreateNewEventView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 21/11/2023.
//

import SwiftUI

struct CreateNewEventView: View {
    @Binding var Events: [Event]
    @State var title = ""
    @State var description = ""
    @State var EventStartDate: Date = Date.now
    @State var EventEndDate: Date = Date.now
    @State var showAlert = 0.0
    
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        Text("Fill up all details!")
            .opacity(showAlert)
        
        List{
            Section(header: Text("Details")){
                TextField("Titles", text: $title)
                TextField("Description", text: $description)
            }
            .listRowBackground(Color.orange.opacity(0.8))
            
            Section(header: Text("Date")){
                DatePicker(
                    "Start Date",
                    selection: $EventStartDate,
                    displayedComponents: [.date]
                )
                
                DatePicker(
                    "End Date",
                    selection: $EventEndDate,
                    displayedComponents: [.date]
                )
            }
            .listRowBackground(Color.orange.opacity(0.8))
            
            Section(header: Text("Create")){
                Button(){
                    if(title != "" && description != ""){
                        Events.append(Event(title: title, details: description, startDate: EventStartDate, endDate: EventEndDate))
                        dismiss()
                    }
                    else{
                        showAlert = 1.0
                    }
                }label:{
                    Text("Create")
                }
                
                Button(){
                    dismiss()
                }label:{
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
            }
            .listRowBackground(Color.orange.opacity(0.8))
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Create New Event")
    }
}
