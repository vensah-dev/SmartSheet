//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 21/11/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                NavigationLink(destination: {
                    VStack{
                        Text("Hello, world!")
                    }
                }, label:{
                    Text("So this is a navigation link")
                })
                .navigationTitle("HomeView")
            }
        }
    }
}
#Preview {
    HomeView()
}
