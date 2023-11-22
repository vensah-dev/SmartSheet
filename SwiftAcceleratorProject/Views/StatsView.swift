//
//  StatsView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 18/11/2023.
//

import SwiftUI

struct StatsView: View {
    @State var suggestions: [Test] = [
        Test(title: "Math Paper 1 2022"),
        Test(title: "Math Paper 2 2022"),
        Test(title: "Math paper 1 2023"),
        Test(title: "Math Paper 2 2023"),
        Test(title: "Math Paper 1 2024"),
        Test(title: "Math Paper 2 2024"),
    ]
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
            
            VStack{
                Text("This week's streak")
            }
            .padding()
            
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
            
            
            Text("Today's suggestion")
                .fontWeight(.heavy)
                .bold()
            
            List {
                Section("Today's suggestion") {
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
    }
    
    
    
}

#Preview {
    StatsView()
}

