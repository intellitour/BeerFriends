//
//  SideMenuOptionsView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 08/12/21.
//

import SwiftUI

struct SideMenuOptionsView: View {
    var menuOption: SideMenuOptions
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: menuOption.icon)
                .frame(width: 24, height: 24)
            
            Text(menuOption.description)
                .font(.system(size: 15, weight: .semibold))
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 5)
    }
}

struct SideMenuOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionsView(menuOption: .configurations)
    }
}
