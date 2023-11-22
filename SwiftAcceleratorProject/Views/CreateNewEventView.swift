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
        NavigationStack{
            
            List{
                Section(header: Text("Details")){
                    TextField("Titles", text: $title)
                        
                    
                    TextField("Description", text: $description)
                        .foregroundStyle(Color("orangeText"))
                }
                .listRowBackground(Color("lightOrange"))
                
                
                Section(header: Text("Date")){
                    DatePicker(
                        "Start Date",
                        selection: $EventStartDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .tint(Color("darkOrange"))
                    
                    DatePicker(
                        "End Date",
                        selection: $EventEndDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .foregroundStyle(Color("darkOrange"))
                    
                }
                .listRowBackground(Color("lightOrange"))
                
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
                            .foregroundStyle(Color("orangeText"))
                    }
                    
                    Button(){
                        dismiss()
                    }label:{
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                }
                .listRowBackground(Color("lightOrange"))
            }
            .scrollContentBackground(.hidden)
            .opacity(0.8)
            .navigationTitle("Create New Event")
            
            Text("Fill up all details!")
                .opacity(showAlert)
                .foregroundStyle(.red)
        }
    }
}
