//
//  ContentView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/11/21.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel

    @Environment(\.colorScheme) var colorScheme

    @State
    private var dummy: String = UUID().uuidString
    
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
            
        }
        .onAppear(perform: getUser)
//        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onChange(of: isDarkMode) { _ in
            dummy = UUID().uuidString
        }
        .onChange(of: colorScheme) { newValue in
            isDarkMode = newValue == .dark
        }
    }
}
