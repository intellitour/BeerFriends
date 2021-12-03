//
//  ContentView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/11/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    func getUser () {
         sessionStore.listen()
     }

    var body: some View {
        Group {
            if sessionStore.session != nil {
                Text("Hello user!")
                    .onTapGesture {
                        sessionStore.signOut()
                    }
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
