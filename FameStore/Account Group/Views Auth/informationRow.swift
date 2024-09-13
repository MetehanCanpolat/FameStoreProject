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
            Text(info)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.headline)
                
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
        
        
    }
}

#Preview {
    informationRow(title: "Name", info: "Metehan Canpolat")
}
