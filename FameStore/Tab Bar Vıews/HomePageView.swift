//
//  HomePageView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack{
            HeaderView()
            
          ScrollView{
                ProductSliderView()
                  .padding(.vertical, 20)
                Image(systemName: "minus")
                    .resizable()
                    .frame(width: 140, height: 2)
                    .padding(.top, 10)
                    .foregroundColor(.black.opacity(0.3))
                 //horizontal scrollview
                productListView()
                  .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    
    }
}

#Preview {
    HomePageView()
}
