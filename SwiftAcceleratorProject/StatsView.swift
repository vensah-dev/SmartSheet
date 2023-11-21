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
    var body: some View {
        NavigationStack{
            Text("Today's suggestion")
                .fontWeight(.heavy)
                .bold()
            List(suggestions, id: \.id){ i in
                Text(i.title)
                    .listRowBackground(Color.red)
                // Add more items as needed
            }
            
            
            
            
        }
        
        
    }
}





#Preview {
    StatsView()
}
