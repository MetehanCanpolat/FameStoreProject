//
//  AccountPageView.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct AccountPageView: View {
    @EnvironmentObject var viewModel : AuthViewModel

    //JWT
    

    var body: some View {
        
        Group {
            if viewModel.userSession != nil {
                ProfileView()
            } else {
                LoginView()
                
            }
            
        }
    }
}

#Preview {
    AccountPageView()
}
