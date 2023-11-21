//
//  HomeView.swift
//  SwiftAcceleratorProject
//
//  Created by Venkatesh Devendran on 20/11/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .foregroundColor(Color(red: 1.0, green: 0.9490196078431372, blue: 0.8705882352941177))
                    .padding()
                    .offset(y: -450)
                    .frame(width: 350, height: 200)
                RoundedRectangle(cornerRadius: 20.0)
                    .foregroundColor(Color(red: 1.0, green: 0.6313725490196078, blue: 0.0784313725490196))
                        .padding()
                        .frame(width: 250 , height: 200)
                        .offset(x: -63, y: -450)
                Text("Current\nStreak")
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 23))
                    .offset(x: -114, y: -462)
                Circle()
                    .foregroundColor(Color.white)
                    .frame(width: 100, height: 100)
                    .offset(x: -15, y: -460)
                    .opacity(0.5)
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 75, height: 75)
                    .offset(x: -15, y: -460)
                    .opacity(0.8)
                Text("Best Streak")
                    .bold()
                    .foregroundColor(.orange)
                    .font(.system(size: 18))
                    .offset(x: 103, y: -505)
                Text(">")
                    .foregroundColor(/*@START_MENU_TOKEN@*/Color.pink/*@END_MENU_TOKEN@*/)
                    .offset(x: -15, y: -505)
                }
            }
        }
    }

#Preview {
    HomeView()
}
