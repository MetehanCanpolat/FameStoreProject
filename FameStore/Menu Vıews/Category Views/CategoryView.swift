//
//  CategoryView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var categories: [String] = []
    @State private var isShowingProducts = false
    @State private var selectedCategory: String? // Seçilen kategoriyi saklıyoruz
    var body: some View {
        NavigationView{
            
            VStack {
                
                Text("All Products")
                    .frame( width: UIScreen.main.bounds.width * 0.9 , alignment: .leading)
                    .font(Font.custom("Georgia", size: 32))
                
                if categories.isEmpty {
                    Text("Loading categories...") // Veriler yüklenirken gösterilecek
                } else {
                    // Kategorileri listelemek için ForEach
                    VStack{
                        ForEach(categories, id: \.self) { category in
                            Button {
                                selectedCategory = category
                                isShowingProducts = true
                                print("Selected category: \(category.capitalized)") // Debug için
                            } label: {
                                Text(category.capitalized) // Kategori ismini göster
                                    .font(Font.custom("Georgia", size: 23))
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            .sheet(isPresented: $isShowingProducts) {
                                if let selectedCategory = selectedCategory {
                                    CategoriesProductView(category: selectedCategory) // Seçili kategoriyi CategoriesProductView'e gönder
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                    }
                }
                
                Spacer()
            }
            .onAppear {
                Task {
                    do {
                        self.categories = try await getAllCategories()
                    } catch {
                        print("Failed to fetch categories: \(error)")
                    }
                }
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.black)
                Text("Back")
                    .foregroundColor(.black)
                
            })
            
            
            
            
        }
    }
}

#Preview {
    CategoryView()
}
