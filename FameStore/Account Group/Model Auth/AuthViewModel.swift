//
//  AuthViewModel.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreCombineSwift
import Combine
//FORM DOĞRULAMA

protocol AuthenticationFormProtocol {
    var formValid : Bool { get }
}

@MainActor
class AuthViewModel : ObservableObject {
    @Published var userSession : FirebaseAuth.User?
    @Published var currentUser : User?
    
    //JWT
    

    init() {
        self.userSession = Auth.auth().currentUser
        
        // fetch usera yazdığımız firebase kodunu getiren kodu burdan çağırıyo getirmeye çalışıyoruz
        
        Task {
            await fetchUser()
        }
    }
    
    // GİRİŞ YAPMA KISMI
    func signIn(withEmail email: String, password: String) async throws {
        
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("DEBUG: failed sign in \(error.localizedDescription)")
        }
        
        
        
    }
    
    func createUser(witheEmail email: String, password: String, fullName: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            
            //KULLANICIYI OLUŞTURDUKTAN SONRA HESAP EKRANINA OLUŞTURULAN HESAIN BİLGİLERİNİ GETİRMEK İÇİN DURUP FETCH İ ÇAĞIRIYORUZ
            await fetchUser()
            
        }catch{
            print("DEBUG \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do{
            try Auth.auth().signOut() // kullanıcının oturumunu backend de kapatıyor
            self.userSession = nil // kullanıcının oturumunu siliyor ve giriş ekranına götürüyor
            self.currentUser = nil // mevcut kullanıcının veri modellerini de siler ki biz başka kullanıcıyla girdiğimizde onun verilerini getirmesin
        }catch{
            print("DEBUG: failed tı signout \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is \(String(describing: self.currentUser))")
    }
    
    
    
    
    
}


