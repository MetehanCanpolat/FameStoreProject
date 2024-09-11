//
//  ShoppingBagView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI
import CoreData

struct ShoppingBagView: View {
    @Environment(\.presentationMode) var presentationMode
    var isTabViewActive: Bool
    // Core Data'dan veri çekmek için FetchRequest kullanıyoruz
    @FetchRequest(
        entity: AddedProductEntity.entity(),
        sortDescriptors: []
    ) var addedProducts: FetchedResults<AddedProductEntity>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Ürünlerin toplam fiyatını hesaplamak için
      var totalPrice: Double {
          addedProducts.reduce(0) { $0 + $1.price }
      }
    

    var body: some View {
        NavigationView {
                VStack{
                   
                    ScrollView(showsIndicators: true) {
                
                            // Core Data'dan gelen ürünlerimizi listelemek için ForEach kullanıyoruz
                            ForEach(addedProducts) { product in
                                VStack {
                                    HStack{
                                        if let imageURL = product.image, let url = URL(string: imageURL) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 50, height: 50)
                                            } placeholder: {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text(product.title ?? "Unknown Title")
                                                .font(Font.custom("Gerorgia", size: 15))
                                            Text("\(product.price, specifier: "%.2f") $")
                                                .font(.subheadline)
                                                //.multilineTextAlignment(.trailing)
                                        }
                                    }
                                    Image(systemName: "minus")
                                        .resizable()
                                        .frame(width: 140, height: 1)
                                        .padding(.top, 10)
                                        .foregroundColor(.black.opacity(0.3))
                                    HStack{
                                      //delete button
                                        Spacer()
                                        Button(action: {
                                        deleteProduct(product: product)
                                                          }) {
                                                              Image(systemName: "trash")
                                                                  .foregroundColor(.gray)
                                        }
                                        //delete button
                                    }
                                    
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.85)
                                .padding(.vertical, 5)
                            }
                        .padding()
                        
                        //TOTAL PRİCE
                        
                        VStack {
                                              HStack {
                                                  Spacer()
                                                  Text("Total Price: \(totalPrice, specifier: "%.2f") $")
                                                      .font(.title2)
                                                      .bold()
                                                      .padding(.trailing, 20)
                                              }
                                              .padding(.top, 20)
                                          }
                        
                        
                        
                    }

                }
   
            .navigationTitle("Shopping Bag")
            //BACK BUTTON
            .navigationBarItems(leading: isTabViewActive ? AnyView(EmptyView()) : AnyView(
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.blue)
                    Text("Back")
                }
            ))
        }
    }
    
    // Core Data'dan bir ürünü silmek için fonksiyon
    private func deleteProduct(product: AddedProductEntity) {
        viewContext.delete(product) // İlgili ürünü context'ten siler
        
        do {
            try viewContext.save() // Değişiklikleri kaydeder
            print("Product deleted successfully.")
        } catch {
            print("Error deleting product: \(error.localizedDescription)")
        }
    }
    
}
#Preview {
    ShoppingBagView( isTabViewActive: false)
}
