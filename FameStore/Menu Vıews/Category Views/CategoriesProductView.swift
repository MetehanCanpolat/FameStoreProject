//
//  CategoriesProductView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct CategoriesProductView: View {
    var category: String
    @State private var products: [productModel] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingDetail = false
    @State private var selectedProduct: productModel?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Dizinin sınırlarını kontrol ederek güvenli dilimleme

                    
                    ForEach(products) { product in
                        Button{
                            selectedProduct = product
                            isShowingDetail = true
                            print("Selected product: \(product.title)") // Debug için ürün başlığını yazdırıyoruz
                            
                        }label: {
                            //İMAGE İLE TEXTLERİ AYIRDIM
                            HStack(alignment: .center) {
                                AsyncImage(url: URL(string: product.image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75)
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    // Ürün başlığının ilk üç kelimesini almak için "components" fonksiyonu
                                    Text(product.title.components(separatedBy: " ").prefix(3).joined(separator: " "))
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding(.bottom, 5)
                                    
                                    Text("Price: \(product.price, specifier: "%.2f") $")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                        }
                        .padding()
                      
                    }
                }
                .padding()
                
          
              
            }
            .navigationTitle("\(category.capitalized)")
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.blue)
                Text("Back")
            })
            .onAppear {
                Task {
                    do {
                        self.products = try await getProductsByCategory(category)
                    } catch {
                        print("Failed to fetch products: \(error)")
                    }
                }
            }
            .sheet(isPresented: $isShowingDetail) {
                if let selectedProduct = selectedProduct {
                    ProductDetailView(product: selectedProduct)
                }
            }
        }
    }
}



// API'den kategorilere göre ürünleri çekme fonksiyonu
func getProductsByCategory(_ category: String) async throws -> [productModel] {
    let apiUrl = "https://fakestoreapi.com/products/category/\(category)"
    
    guard let url = URL(string: apiUrl) else {
        throw productError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw productError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([productModel].self, from: data)
    } catch {
        throw productError.invalidData
    }
}

#Preview {
    CategoriesProductView(category: "jewelery")
}
