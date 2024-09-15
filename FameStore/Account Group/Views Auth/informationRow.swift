//
//  informationRow.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI

struct informationRow: View {
    let title: String
    let info : String
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .font(Font.custom("Georgia", size: 25))
            Text(info)
                .foregroundColor(Color(.darkGray))
                //.fontWeight(.semibold)
                .font(Font.custom("Georgia", size: 22))
                
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
        
        
    }
}

#Preview {
    informationRow(title: "Name", info: "Metehan Canpolat")
}
