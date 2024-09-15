//
//  ContentView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI
import Firebase
import CoreData

struct ContentView: View {
    
    @State private var selectedTab = 2
    
    
    @FetchRequest(
        entity: AddedProductEntity.entity(),
        sortDescriptors: []
    ) var addedProducts: FetchedResults<AddedProductEntity>
  
    
    var body: some View {
       
            VStack{
                
                HeaderView()
                
                TabView(selection: $selectedTab) {
                    
                    AccountPageView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Account")
                        }
                        .tag(1)
                    
                    HomePageView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(2)
                    
                    ShoppingBagView(isTabViewActive: true)
                        .badge(Text("\(addedProducts.count)"))
                        .tabItem {
                            Label("Shopping Bag", systemImage: "bag")
                        }
                        .tag(3)
                }
            }
        
    }
}

#Preview {
    ContentView()
}
