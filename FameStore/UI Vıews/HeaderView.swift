//
//  HeaderView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct HeaderView: View {
    
    @State private var isShowingCategoryView = false
    @State private var isShowingSerachingview = false

    var body: some View {
        ZStack{
            HStack{
                Button{
                  isShowingCategoryView = true
                }label: {
                    Image(systemName: "line.horizontal.2.decrease.circle")
                        .resizable()
                        .foregroundColor(.black)
                        .aspectRatio(contentMode: .fit)
                        .padding(.leading, 5)
                        
                    
                }
                .fullScreenCover(isPresented: $isShowingCategoryView) {
                    CategoryView()
                }
                .frame(width: 30)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                ZStack{
                    Text("FAME")
                            .font(Font.custom("Georgia", size: 30))
                            .padding(.top, 8.0)
                            .padding(.leading, 12.0)
                            .foregroundColor(.gray)
                        Text("FAME")
                            .font(Font.custom("Georgia", size: 30))
                }
                
                Button{
                    isShowingSerachingview = true
                    
                }label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .foregroundColor(.black)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 5)
                       
                    
                }
                .fullScreenCover(isPresented: $isShowingSerachingview) {
                    ProductSearchView()
                }
                .frame(width: 30)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
            }
       
        }
        //ZSTACK SONU. ZSTACK KODLARI:
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(.white)
        .zIndex(1)
    }
}

#Preview {
    HeaderView()
}
