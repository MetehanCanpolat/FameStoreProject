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
    @Environment(\.managedObjectContext) private var viewContext
    var isTabViewActive: Bool
    // Core Data'dan veri çekmek için FetchRequest kullanıyoruz
    @FetchRequest(
        entity: AddedProductEntity.entity(),
        sortDescriptors: []
    ) var addedProducts: FetchedResults<AddedProductEntity>
  
    // Ürünlerin toplam fiyatını hesaplamak için
    var totalPrice: Double {
        addedProducts.reduce(0) { $0 + $1.price }
    }
    @State private var isShowingPaymentView = false

    
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Shopping Bag")
                    .frame( width: UIScreen.main.bounds.width * 0.9 , alignment: .leading)
                    .font(Font.custom("Georgia", size: 32))
                
                
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
                                        .font(Font.custom("Gerorgia", size: 15))
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
                                .font(Font.custom("Georgia", size: 23))
                                .padding(.trailing, 20)
                        }
                        .padding(.top, 20)
                        
                        //Buy butonu ve contuniue butonu
                        
                        HStack{
                            /* Button(action: {
                                isShowingContentView = true
                            }, label: {
                                Text("Button")
                            })
                            .sheet(isPresented: $isShowingContentView, content: {
                                ContentView()
                            }) */
                            
                            Spacer()
                            
                            Button{
                                isShowingPaymentView = true
                            }label: {
                                Text("Buy")
                                    .font(Font.custom("Georgia", size: 23))
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 5)
                                    .foregroundColor(.white)
                                    .background(Color(red: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, green: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, blue: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/))
                                    .cornerRadius(10)
                            }
                            .fullScreenCover(isPresented: $isShowingPaymentView, content: {
                                PaymentView()
                            })
                            
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding()
                        
                    }
                    
                }
                
            }
            //BACK BUTTON
            .navigationBarItems(leading: isTabViewActive ? AnyView(EmptyView()) : AnyView(
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                    Text("Back")
                        .foregroundColor(.black)
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
