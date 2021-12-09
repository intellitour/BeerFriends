//
//  ContentView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/11/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    
    func getUser () {
         userSessionStoreViewModel.listen()
     }

    var body: some View {
        Group {
            if userSessionStoreViewModel.userSession != nil {
                FriendListView().environmentObject(userSessionStoreViewModel)
            } else {
                if UserDefaults.standard.string(forKey: "Onboarding") == nil {
                    OnboardingView()
                } else {
                    LoginWrapperView()
                }
            }
            
        }.onAppear(perform: getUser)
    }
}
