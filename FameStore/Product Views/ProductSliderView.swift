//
//  ProductSliderView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct ProductSliderView: View {
    @State private var products: [productModel] = []
    @State private var currentIndex: Int = 0
    @State private var showingDetail = false
    @State private var selectedProduct: productModel? = nil
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    // Belirli bir aralık tanımlanıyor (örneğin, 2. üründen 5. ürüne kadar)
    let productRange: Range<Int> = 1..<6
    
    var body: some View {
        VStack {
            if !products.isEmpty {
                TabView(selection: $currentIndex) {
                    ForEach(productRange, id: \.self) { index in
                        if index < products.count {
                            AsyncImage(url: URL(string: products[index].image)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        selectedProduct = products[index]
                                        showingDetail = true
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                            .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % productRange.count
                            if currentIndex == 0 {
                        currentIndex = productRange.startIndex
                    }
                }
                }
                
            } else {
                //YUKLENIYOR ISARETI
                ProgressView("Loading...")
            }
        }
        .sheet(isPresented: $showingDetail) {
            if let selectedProduct = selectedProduct {
                ProductDetailView(product: selectedProduct)
            }
        }
        .onAppear {
            Task {
                do {
                    self.products = try await getAllProducts()
                } catch {
                    print("Error loading products: \(error)")
                }
            }
        }
    }
}

#Preview {
    ProductSliderView()
}
