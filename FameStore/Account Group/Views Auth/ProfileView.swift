//
//  ProfileView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser {
            VStack{
                HStack{
                    Text(user.initials)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(Color(.systemGray3))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .symbolEffect(.pulse, options: .repeat(3))
                }
                .padding(.bottom, 100)
                VStack(spacing: 12){
                    informationRow(title: "Full Name", info: user.fullName)
                    informationRow(title: "e-mail", info: user.email)
                }
                VStack{
                    Button{
                        viewModel.signOut()
                    } label: {
                        Text("Sign Out")
                        Image(systemName: "arrowshape.left.circle.fill")
                    }
                    
                    Button{
                        print("account deleted...")
                    } label: {
                        Text("Delete Account")
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .font(.footnote)
                .padding(.top, 50)
            }
           
        }
           
            
    }
    
}

#Preview {
    ProfileView()
}
