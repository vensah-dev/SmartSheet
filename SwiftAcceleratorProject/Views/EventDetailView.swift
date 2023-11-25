//
//  EventDetailView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 22/11/2023.
//

import SwiftUI

struct EventDetailView: View {
    @State var event: Event
    @Binding var Events: [Event]
    @State var index = 0
    @State var editModeActive = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Date")){
                    DatePicker(
                        "Start Date",
                        selection: $event.startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .tint(Color("darkOrange"))
                    .disabled(!editModeActive)
                    
                    DatePicker(
                        "End Date",
                        selection: $event.endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundColor(Color("orangeText"))
                    .tint(Color("darkOrange"))
                    .disabled(!editModeActive)
                }
                
                Section(header: Text("Description")){
                    TextField("", text: $event.details)
                        .disabled(!editModeActive)
                }
            }
            .opacity(0.8)
            .navigationTitle($event.title)
            .navigationBarTitleDisplayMode(editModeActive ? .inline : .large)
        }
        .navigationBarItems(trailing:
            Button(action: {
            editModeActive.toggle()
            }) {
                Text(editModeActive ? "Done" : "Edit")
            }
        )
        .animation(.default)
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
}


