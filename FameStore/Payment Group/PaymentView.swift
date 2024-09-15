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
    @Environment(\.managedObjectContext) private var viewContext
    // Core Data'dan veri çekmek için FetchRequest kullanıyoruz
    @FetchRequest(
        entity: AddedProductEntity.entity(),
        sortDescriptors: []
    ) var addedProducts: FetchedResults<AddedProductEntity>
    
    // Ürünlerin toplam fiyatını hesaplamak için
    var totalPrice: Double {
        addedProducts.reduce(0) { $0 + $1.price }
    }
    
    @State private var showAlert = false
    
    @State private var cardNumber = ""
    @State private var cardOwnerName = ""
    @State private var cvvNumber = ""
    @State private var cardDate = ""
    
    let maxLength = 16
    let maxLengthCvv = 3
    
    var body: some View {
        
        NavigationView{
            VStack{
                
                //SEPETTEKI URUNLERINI GOSTEREN HORIZONTAL BIR SCROLLVIEW
                HStack{
                    if !addedProducts.isEmpty {
                        ScrollView(.horizontal){
                            HStack {
                                ForEach(addedProducts){ product in
                                    
                                    VStack {
                                        if let imageURL = product.image, let url = URL(string: imageURL) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 65, height: 65)
                                            } placeholder: {
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 65, height: 65)
                                            }
                                        }
                                        
                                        Text(product.title?.components(separatedBy: " ").prefix(3).joined(separator: " ") ?? "")
                                            .font(Font.custom("Georgia", size: 18))
                                            .foregroundColor(.black)
                                            .frame(width: 100)
                                        
                                        Text("Price: \(product.price, specifier: "%.2f") $")
                                            .font(Font.custom("Georgia", size: 15))
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    
                                }
                            }
                            
                        }
                    } else {
                        
                        Text("No Product")
                    }
                    
                    
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.height * 0.25)
                .border(Color.black)
                .padding(.top, -75)
                
                HStack {
                    Spacer()
                    Text("Total Price: \(totalPrice, specifier: "%.2f") $")
                        .font(Font.custom("Georgia", size: 23))
                        .padding(.trailing, 20)
                }
                .padding(.vertical)
                
                VStack(alignment: .leading){
                    Text("Card Owner Name")
                        .font(Font.custom("Georgia", size: 19))
                    TextField("Name", text: $cardOwnerName)
                        .autocapitalization(.words)
                        .onChange(of: cardOwnerName) { Value in
                            let letterFiltered = Value.filter { $0.isLetter }
                        }
                        .padding(.top, -5.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                VStack(alignment: .leading){
                    Text("Card Number")
                        .font(Font.custom("Georgia", size: 19))
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
                        .padding(.top, -5.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.bottom)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Card Date")
                            .font(Font.custom("Georgia", size: 19))
                        DatePickerView()
                            .padding(.top, -8)
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text("CVV")
                            .font(Font.custom("Georgia", size: 19))
                        TextField("CVV", text: $cvvNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: cvvNumber) { cvvValue in
                                let cvvFiltered = cvvValue.filter { $0.isNumber}
                                //3 RAKAM SINIRLAMASI
                                if cvvFiltered.count <= maxLengthCvv {
                                    cvvNumber = cvvFiltered
                                } else {
                                    cvvNumber = String(cvvFiltered.prefix(maxLengthCvv)) // Truncate to maxLength
                                }
                                
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 50)
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                //PAYMENT BUTTON
                HStack{
                    Button{
                        deleteAllProducts()
                        showAlert = true
                    } label: {
                        HStack{
                            Text("Payment")
                            Image(systemName: "arrow.right")
                            
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.black))
                    .disabled(!formValid)
                    .opacity(formValid ? 1.0 : 0.5)
                    .cornerRadius(10)
                    .padding(.top, 15)
                    .alert(isPresented: $showAlert) {
                                   Alert(title: Text("Success"),
                                         message: Text("Payment Success"),
                                         dismissButton: .default(Text("OK")))
                               }
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
    
    //delete func
    private func deleteAllProducts() {
        // Her bir ürünü manuel olarak sil
        for product in addedProducts {
            viewContext.delete(product)
        }
        
        do {
            try viewContext.save() // Değişiklikleri kaydeder ve UI'yi günceller
            print("All products deleted successfully.")
        } catch {
            print("Error deleting all products: \(error.localizedDescription)")
        }
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

// BUTON AKTIFLESME SARTI

extension PaymentView {
    var formValid: Bool {
        return !cardOwnerName.isEmpty
        && !cardNumber.isEmpty
        && cardNumber.count == 19
        && !DatePickerView().years.isEmpty
        && !DatePickerView().months.isEmpty
        && !cvvNumber.isEmpty
        && cvvNumber.count == 3
        
    }
}

#Preview {
    PaymentView()
}
