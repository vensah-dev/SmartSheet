//
//  StatsView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct StatsView: View {      
    @State public var suggestions: [ScannedImage] = []
    @StateObject private var dataManager = DataManager()
    @State var DaysOfTheWeek: [String] = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
    ]
    
    var body: some View {
        NavigationStack{
            Image("Group 63")
                .resizable()
                .scaledToFit()
            
            HStack(spacing: 10){
                ForEach(DaysOfTheWeek, id: \.self){ x in
                    VStack{
                        Image(systemName: "flame.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:24)
                            .foregroundColor(.orange)
                        
                        Text(x)
                            .font(.system(size: 10, weight:.black))
                    }
                    .padding(11)
                }
            }
            
            List {
                Section(header: Text("Today's suggestion").font(.system(size: 17, weight: .bold, design: .rounded))){
                    ForEach(suggestions, id: \.id){ i in
                        NavigationLink(destination: EmptyView()) {
                            Text(i.title)
                                
                        }
                        .listRowBackground(Color("lightOrange"))
                    }
                    
                }
            }
            .background(Color(UIColor(white: 0, alpha: 0)))
            .scrollContentBackground(.hidden)
            .navigationTitle("Streaks")
        }
        .onAppear{
            suggestions = dataManager.scannedImages.filter{$0.used < 5}
        }
    }
}

#Preview {
    StatsView()
}

