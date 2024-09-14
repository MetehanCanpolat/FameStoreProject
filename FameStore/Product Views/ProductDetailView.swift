//
//  ProductDetailView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import CoreData
import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let product: productModel
    @Environment(\.dismiss) var dismiss
    @State private var basket: [AddedProduct] = []
    @State private var ShowingShoppingBagView = false
    let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext

    var body: some View {
        NavigationView {
            VStack {
            
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.5)

                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                }
                Text(product.title)
                    .font(Font.custom("Georgia", size: 24))
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                HStack{
                    Spacer()
                    Text("Price: \(product.price, specifier: "%.2f") $")
                        .font(Font.custom("Georgia", size: 24))
                        .foregroundColor(.gray)
                        .padding(.trailing, 20.0)
                }

                // Sepete ekleme butonu
                HStack {
                    Spacer()
                    Button(action: {
                        addProductToBasket()
                        ShowingShoppingBagView = true
                    }) {
                        Text("Add Basket")
                            .font(Font.custom("Georgia", size: 15))
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .padding([.bottom, .trailing], 20)
                    .fullScreenCover(isPresented: $ShowingShoppingBagView) {
                        ShoppingBagView(isTabViewActive: false)
                    }
                }
              
                HStack{
                    Text("Product Description")
                        .font(Font.custom("Georgia", size: 20))
                        .padding(.leading, 20.0)
                    Spacer()
                       
                }
                Text(product.description)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .padding(5)
            }
            .ignoresSafeArea()
        }
    }

    // Ürünü sepete ekleyen ve Core Data'ya kaydeden fonksiyon
    func addProductToBasket() {
        let newProduct = AddedProduct(image: product.image, title: product.title, price: product.price)
        basket.append(newProduct)

        // Core Data'ya kaydetme işlemi
        let AddedProductEntity = NSEntityDescription.insertNewObject(forEntityName: "AddedProductEntity", into: managedObjectContext)
        AddedProductEntity.setValue(product.image, forKey: "image")
        AddedProductEntity.setValue(product.title, forKey: "title")
        AddedProductEntity.setValue(product.price, forKey: "price")
        AddedProductEntity.setValue(product.id, forKey: "id")

        do {
            try managedObjectContext.save()
            print("Product added to Core Data: \(newProduct.title)")
        } catch {
            print("Failed to save product: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProductDetailView(product: productModel(id: 1, title: "ürün adi", price: 10, category: "kategori", image: "photo", description: "açıklama"))
}
