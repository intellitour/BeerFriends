//
//  SideMenuHeaderView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 08/12/21.
//

import SwiftUI

struct SideMenuHeaderView: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                withAnimation(.spring()) {
                    isShowing.toggle()
                }
            }, label: {
                Image(systemName: K.Icon.close)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .padding()
            })

            VStack(alignment: .leading) {
                Image(systemName: K.Icon.PersonCircle)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
                
                Text("Wesley Marra")
                    .font(.system(size: 24, weight: .semibold))
                
                Text("wamarra@gmail")
                    .font(.system(size: 14))
                    .padding(.bottom, 24)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("Nível:").bold()
                        Text("Strong")
                    }
                    
                    HStack(spacing: 4) {
                        Text("Cervejas:").bold()
                        Text("256")
                    }
                    Spacer()
                }
                
                Spacer()
            }.padding()
        }
    }
}

struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView(isShowing: .constant(true))
    }
}
