//
//  ProductSearchView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct ProductSearchView: View {
    @State private var searchText: String = ""
    @State private var products: [productModel] = []
    @State private var filteredProducts: [productModel] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedProduct: productModel?
    @State private var isShowingDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Prouct Search")
                    .frame( width: UIScreen.main.bounds.width * 0.9 , alignment: .leading)
                    .font(Font.custom("Georgia", size: 32))
                
                // Arama Çubuğu
                TextField("Search products...", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText, perform: { _ in
                        filterProducts()
                    })
                
                // Yükleniyor durumu
                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    ScrollView(showsIndicators: true) {
                        VStack(spacing: 20) {
                            // Dizinin sınırlarını kontrol ederek güvenli dilimleme
                            ForEach(filteredProducts) { product in
                                Button {
                                    selectedProduct = product
                                    isShowingDetail = true
                                    print("Selected product: \(product.title)") // Debug için ürün başlığını yazdırıyoruz
                                } label: {
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
                                                .font(Font.custom("Georgia", size: 20))
                                                .foregroundColor(.black)
                                                .padding(.bottom, 5)
                                            
                                            Text("Price: \(product.price, specifier: "%.2f") $")
                                                .font(Font.custom("Georgia", size: 15))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .sheet(isPresented: $isShowingDetail) {
                                    if let selectedProduct = selectedProduct {
                                        ProductDetailView(product: selectedProduct)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            
            .onAppear {
                loadProducts()
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
    
    // Ürünleri API'den Çekme Fonksiyonu
    private func loadProducts() {
        isLoading = true
        Task {
            do {
                let fetchedProducts = try await getAllProducts()
                products = fetchedProducts
                filteredProducts = fetchedProducts
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = "Failed to load products: \(error.localizedDescription)"
            }
        }
    }
    
    // Arama Sonucuna Göre Ürünleri Filtreleme Fonksiyonu
    private func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                product.title.lowercased().contains(searchText.lowercased()) ||
                product.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct ProductSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ProductSearchView()
    }
}
