//
//  CustomTextField.swift
//  BeerFriends
//
//  Created by Wesley Marra on 01/12/21.
//

import SwiftUI

struct CustomTextField: View {
    
    @State private var offset: CGFloat = 10.0
    
    var image: String
    var title: String
    @Binding var value: String
    var animation: Namespace.ID
    
    

    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .bottom) {
                Image(systemName: image)
                    .font(.system(size: 22))
                    .foregroundColor(.secondaryColor)
                    .frame(width: 35)
                
                VStack(alignment: .leading, spacing: 6) {
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        if value == "" {
                            Text(title)
                                .font(.caption)
                                .fontWeight(.heavy)
                                .foregroundColor(.gray)
                                .matchedGeometryEffect(id: title, in: animation)
                        }
                        
                        if title == "Senha" {
                            SecureField("", text: $value)
                        } else {
                            TextField("", text: $value)
                        }
                    }
                }
            }
            
            Divider()           
        }
        .padding(.vertical, 10)
        .background(.white.opacity(value != "" ? 1 : 0))
        .animation(.linear(duration: 1.0), value: offset)
    }
}
