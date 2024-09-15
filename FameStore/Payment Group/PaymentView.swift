//
//  PaymentView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 15.09.2024.
//

import SwiftUI
import CoreData

struct PaymentView: View {
    @Environment(\.presentationMode) var presentationMode
    // Core Data'dan veri çekmek için FetchRequest kullanıyoruz
    @FetchRequest(
        entity: AddedProductEntity.entity(),
        sortDescriptors: []
    ) var addedProducts: FetchedResults<AddedProductEntity>
  
    // Ürünlerin toplam fiyatını hesaplamak için
    var totalPrice: Double {
        addedProducts.reduce(0) { $0 + $1.price }
    }
    
    @State private var cardNumber = ""
    @State private var cardOwnerName = ""
    @State private var cvvNumber = ""
    @State private var cardDate = ""
    
    let maxLength = 16
    
    var body: some View {
        
        NavigationView{
            VStack {
                HStack {
                    Spacer()
                    Text("Total Price: \(totalPrice, specifier: "%.2f") $")
                        .font(Font.custom("Georgia", size: 23))
                        .padding(.trailing, 20)
                }
                
                VStack(alignment: .leading){
                    Text("Card Owner Name")
                    
                    TextField("Name", text: $cardOwnerName)
                        .autocapitalization(.words)
                        .onChange(of: cardOwnerName) { Value in
                            let filtered = Value.filter { $0.isLetter }
                        }
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                }
                
                VStack(alignment: .leading){
                    Text("Card Number")
                    TextField("Enter numbers", text: $cardNumber)
                        .keyboardType(.numberPad) // SAYI KLAVYESİ
                        .onChange(of: cardNumber) { newValue in
                            // SADECE SAYI GIRILMESI KOŞULU
                            let filtered = newValue.filter { $0.isNumber }
                            
                            // 16 SAYIYA KOŞUL KOYUYORUZ
                            if filtered.count <= maxLength {
                                cardNumber = formatAsCardNumber(filtered)
                            } else {
                                cardNumber = formatAsCardNumber(String(filtered.prefix(maxLength)))
                            }
                        }
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                
                
                
                
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
    

    func formatAsCardNumber(_ number: String) -> String {
        return number.chunked(into: 4).joined(separator: " ")
    }
}

extension String {
    // RAKAMLARI 4 ER AYIRMAK
    func chunked(into size: Int) -> [String] {
        stride(from: 0, to: self.count, by: size).map { index in
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[startIndex..<endIndex])
        }
    }
}

#Preview {
    PaymentView()
}
