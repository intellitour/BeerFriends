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
            if UserDefaults.standard.string(forKey: "Onboarding") == nil {
                OnboardingView()
            } else {
                if sessionStore.session != nil {
                    Text("Hello user!")
                } else {
                    SignInView()
                }
            }
        }.onAppear(perform: getUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
