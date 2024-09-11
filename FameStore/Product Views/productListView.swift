//
//  productListView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct productListView: View {
  
    @State private var products: [productModel] = []
    @State private var isShowingDetail = false
    @State private var selectedProduct: productModel?
    
    //tüm ürünleri göstermek için
    
    @State private var showAllProductView = false
    
    // Bu, dizinin başlangıç ve bitiş indeksini tanımladığınız yer
    let startIndex = 0
    let endIndex = 5
    
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: true) {
                HStack( spacing: 20) {
                    // Dizinin sınırlarını kontrol ederek güvenli dilimleme
                    let slicedProducts = Array(products.prefix(max(endIndex + 1, products.count)).suffix(max(0, endIndex - startIndex + 1)))
                    
                    ForEach(slicedProducts) { product in
                        Button{
                            selectedProduct = product
                            isShowingDetail = true
                            print("Selected product: \(product.title)") // Debug için ürün başlığını yazdırıyoruz
                            
                        }label: {
                            VStack(alignment: .center){
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
                                //TTITLE ILK ÜÇ KELİMESİNİ ALMAK İÇİN "speratedBy" fonksiyonunu kullanıyoruz
                                Text(product.title.components(separatedBy: " ").prefix(3).joined(separator: " "))
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(width: 100)
                                Text("Price: \(product.price, specifier: "%.2f") $")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
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
            .onAppear {
                Task {
                    do {
                        self.products = try await getAllProducts()
                    } catch {
                        print("Failed to fetch products: \(error)")
                    }
                }
            }
            //ALL PRODUCT BUTTON
            
            Button(action: {
                     showAllProductView = true
                 }) {
                     Text("Show All Products")
                         .font(Font.custom("Georgia", size: 15))
                         .padding(5)
                         .foregroundColor(.white)
                         .background(Color(red: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, green: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, blue: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/))
                         .cornerRadius(10)
                 }
                 .fullScreenCover(isPresented: $showAllProductView) {
                     AllProductsView()
                 }

        

            //ALL PRODUCT BUTTON
        }
    }

}

#Preview {
    productListView()
}
