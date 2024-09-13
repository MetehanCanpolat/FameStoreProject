//
//  RegistrationView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            Image(systemName: "bag")
                .resizable()
                .scaledToFit()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 32)
            
            
            VStack(spacing: 24) {
                inputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                
                inputView(text: $fullName,
                          title: "Full Name",
                          placeholder: "full name"
                )
                inputView(text: $password,
                          title: "Password",
                          placeholder: "password",
                          isSecureField: true
                )
                
                //ŞİFRE OLUŞTURULURKEN İKİ ŞİFRENİN DE AYNI OLDUĞUNU DOĞRU GİRİLDİĞİNİ KONTROL EDİYOR
                
                ZStack{
                    inputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "confirm password",
                              isSecureField: true
                    )
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                            
                        }else {
                            
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                            
                        }
                    }
                }
                         
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button{
                Task{
                    try await viewModel.createUser(witheEmail: email,
                                                   password:password,
                                                   fullName:fullName)
                }
            } label: {
                HStack{
                    Text("Sign Up")
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
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack{
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .font(.system(size: 14))
            }
            .padding(.bottom, 10)
        }
      
                
    }
}

//FORM DOĞRULAMA

extension RegistrationView: AuthenticationFormProtocol{
    var formValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
    
    
}

#Preview {
    RegistrationView()
}

