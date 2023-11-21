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

    
    var body: some View {
        List{
            Section(header: Text("Details")){
                TextField("Titles", text: $title)
                TextField("Description", text: $description)
            }
            
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
            Section(header: Text("Create")){
                Button(){
                    print("Hello")
                    Events.append(Event(title: title, details: description, startDate: EventStartDate, endDate: EventEndDate))
                }label:{
                    Text("Create")
                }
            }
        }
        .navigationTitle("Create New Event")
    }
}
