//
//  SideMenuOptionsView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 08/12/21.
//

import SwiftUI

struct SideMenuOptionsView: View {
    var viewModel: SideMenuViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.icon)
                .frame(width: 24, height: 24)
            
            Text(viewModel.description)
                .font(.system(size: 15, weight: .semibold))
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 5)
    }
}

struct SideMenuOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionsView(viewModel: .configurations)
    }
}
