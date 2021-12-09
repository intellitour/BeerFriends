//
//  SideMenuView.swift.swift
//  BeerFriends
//
//  Created by Wesley Marra on 08/12/21.
//

import SwiftUI
import simd

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.secondaryColor, Color.primaryColor]),
                           startPoint: .top,
                           endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(alignment: .leading) {
                SideMenuHeaderView(isShowing: $isShowing)
                    .frame(height: 240)
                
                ForEach(SideMenuViewModel.allCases, id: \.self) { option in
                    if option == SideMenuViewModel.loggout {
                        SideMenuOptionsView(viewModel: option)
                            .onTapGesture {
                                let result = userSessionStoreViewModel.signOut()
                                if (result) { print("Usuário saiu da sessão") }
                            }
                    } else {
                        NavigationLink(
                            destination: Text(option.description),
                            label: {
                                SideMenuOptionsView(viewModel: option)
                            }
                        )
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true))
    }
}
