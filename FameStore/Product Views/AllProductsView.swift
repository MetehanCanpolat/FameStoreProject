//
//  AllProductsView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI



struct AllProductsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var products: [productModel] = []
    @State private var isShowingDetail = false
    @State private var selectedProduct: productModel?
    
    var body: some View {
        NavigationView {
                VStack {
                    
                    
                    // Buraya tüm ürünlerinizi gösterecek içerikleri ekleyin
                    
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
                                    HStack(alignment: .bottom){
                                        AsyncImage(url: URL(string: product.image)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50)
                                        } placeholder: {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50)
                                        }
                                        
                                        Spacer()
                                        //TEXTLER
                                        
                                        VStack(alignment: .trailing){
                                            Text(product.title)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                
                                                
                                            Text("Price: \(product.price, specifier: "%.2f") $")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        .multilineTextAlignment(.trailing)
                                    }
                                    
                                    .frame(width: UIScreen.main.bounds.width * 0.85)
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
                    .onAppear {
                        Task {
                            do {
                                self.products = try await getAllProducts()
                            } catch {
                                print("Failed to fetch products: \(error)")
                            }
                        }
                    }
                    
                    //Ürünler sonu
                    
                    Spacer()
                }
                .navigationTitle("All Products")
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
    AllProductsView()
}
