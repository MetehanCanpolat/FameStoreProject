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
                
                Text("All Products")
                    .frame( width: UIScreen.main.bounds.width * 0.9 , alignment: .leading)
                    .font(Font.custom("Georgia", size: 32))
                
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        //Dongu ile tum uruleri listeliyoruz
                        ForEach(products) { product in
                            Button{
                                selectedProduct = product
                                isShowingDetail = true
                                //Debuglar icin consola print ettirdim
                                print("Selected product: \(product.title)")
                                
                                
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
                                        Text(product.title.components(separatedBy: " ").prefix(3).joined(separator: " "))
                                            .font(Font.custom("Georgia", size: 18))
                                            .foregroundColor(.black)
                                        
                                        
                                        Text("Price: \(product.price, specifier: "%.2f") $")
                                            .font(Font.custom("Georgia", size: 15))
                                        
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
    AllProductsView()
}
