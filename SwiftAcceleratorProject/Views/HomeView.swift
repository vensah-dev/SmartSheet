//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import SwiftUI

struct HomeView: View {
    @State var streak = 4
    @State var nextStreak = 10
    @State var bestStreak = 7
    @State var StreakCompletion = 40.0
    @State var OrangeText: Color = Color(UIColor(red: 255/255, green: 161/255, blue: 20/255, alpha: 0.8))
    @State var lightOrangeText: Color = Color(UIColor(red: 255/255, green: 242/255, blue: 242/255, alpha: 1))
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("streaksNormal")
                    .resizable()
                    .scaledToFit()
                
                Text(String(streak))
                    .font(.system(size: 72, weight: .bold))
                    .position(x: ((geometry.size.width / 2) - 30), y: ((geometry.size.height / 2) - 20))
                
                Text(String(bestStreak))
                    .font(.system(size: 102, weight: .bold))
                    .position(x: ((geometry.size.width / 2) + 130), y: ((geometry.size.height / 2) + 10))
                
            }
        }
    }
}

#Preview {
    HomeView()
}
