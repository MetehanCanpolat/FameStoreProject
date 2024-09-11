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
            if categories.isEmpty {
                Text("Loading categories...") // Veriler yüklenirken gösterilecek
            } else {
                // Kategorileri listelemek için ForEach
                List(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                        isShowingProducts = true
                        print("Selected category: \(category.capitalized)") // Debug için
                    } label: {
                        Text(category.capitalized) // Kategori ismini göster
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .fullScreenCover(isPresented: $isShowingProducts) {
                        if let selectedCategory = selectedCategory {
                            CategoriesProductView(category: selectedCategory) // Seçili kategoriyi CategoriesProductView'e gönder
                        }
                    }
                }
            }
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
        .navigationTitle("Categories")
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.backward")
                .foregroundColor(.blue)
            Text("Back")
            
        })
      }
    }
}

#Preview {
    CategoryView()
}
