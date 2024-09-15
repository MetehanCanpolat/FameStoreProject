//
//  LoginView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                // image
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.vertical, 32)
                
                // form fields
                // inputtan çağırıyoz direkt
                
                VStack(spacing: 24) {
                    inputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    inputView(text: $password,
                              title: "Password",
                              placeholder: "password",
                              isSecureField: true
                    )
                             
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                
                //DISMISS YAPARAK ACCOUNTA DÖNEBİLİRİM!
                Button{
                    Task{
                        try await viewModel.signIn(withEmail: email,
                                                   password: password)
                    }
                } label:{
                    HStack {
                        
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                       
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.black))
                .disabled(!formValid)
                .opacity(formValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                // sign up button
                
                NavigationLink{
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .font(Font.custom("Georgia", size: 18))
                            .foregroundColor(.black)
                        Text("Sign Up")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(Font.custom("Georgia", size: 18))
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                .padding(.bottom, 10)
                
            }
        }
    }
}

// FORM DOĞRULAMA

extension LoginView: AuthenticationFormProtocol{
    var formValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
    
    
}

#Preview {
    LoginView()
}
