//
//  ImageView.swift
//  SwiftAcceleratorProject
//
//  Created by jeffrey on 21/11/23.
//

import SwiftUI

struct ImageDetail: View {
    @State var image: UIImage
    @Binding var title: String
    @Binding var caption: String
    
    var body: some View {
        VStack {
            TextField("", text: $title)
                .font(.title)
                .padding()
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .navigationBarTitle("", displayMode: .inline)
            
        }
    }
}
