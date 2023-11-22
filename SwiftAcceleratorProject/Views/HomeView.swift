//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import SwiftUI

struct HomeView: View {
    @State var Streak = 4
    @State var NextStreak = 10
    @State var BestStreak = 7
    @State var StreakCompletion = 40.0
    @State var OrangeText: Color = Color(UIColor(red: 255/255, green: 161/255, blue: 20/255, alpha: 0.8))
    
    @State var lightOrangeText: Color = Color(UIColor(red: 255/255, green: 242/255, blue: 242/255, alpha: 1))
    
    var body: some View {
        NavigationStack{
            //Streaks Widget
            ZStack {
                Image("StreaksHome")
                    .opacity(0.8)
                
                VStack{
                    HStack{
                        Text("""
                             Current
                             Streak
                             """)
                            .foregroundStyle(lightOrangeText)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Text(String(Streak))
                            .foregroundStyle(OrangeText)
                            .font(.system(size: 64, weight: .semibold, design: .rounded))
                            .padding(.init(top: 0, leading: 38, bottom: 0, trailing: 0))
                    }
                    .frame(maxWidth: .infinity, maxHeight: 170.4, alignment: .leading)
                    .padding(.init(top: 310, leading: 25, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
                    VStack{
                        
                        ProgressView("", value: StreakCompletion, total: 100)
                            .tint(lightOrangeText)
                            .frame(width: 202)

                        Text("\(NextStreak - Streak) days to go")
                            .opacity(0.47)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .padding(.init(top: 0, leading: 125, bottom: 0, trailing: 0))

                    }
                    .padding(.init(top: 0, leading: 0, bottom: 50, trailing: 135))
                }
                .padding(.init(top: 0, leading: 0, bottom: 250, trailing: 0))
                VStack{
                    Text("Best Streak")
                        .foregroundStyle(OrangeText)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .padding(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    Text(String(BestStreak))
                        .foregroundStyle(OrangeText)
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                }
                .padding(.init(top: 0, leading: 245, bottom: 0, trailing: 0))
                
            }
            
            
        }
    }
}

#Preview {
    HomeView()
}
