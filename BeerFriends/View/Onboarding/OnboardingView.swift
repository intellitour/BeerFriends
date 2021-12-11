//
//  OnboardingView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 18/11/21.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var currentPageIndex = 0
    @State private var isPresenting = false
    
    var subviews = [
            UIHostingController(rootView: OnboardingSubview(
                imageName: K.Omboarding.ImageOne)),
            
            UIHostingController(rootView: OnboardingSubview(
                imageName: K.Omboarding.ImageTwo)),
            
            UIHostingController(rootView: OnboardingSubview(
                imageName: K.Omboarding.ImageThree))
        ]
    
    var body: some View {
            VStack {
                OnboardingViewController(
                    currentPageIndex: $currentPageIndex,
                    viewControllers: subviews)
                    .edgesIgnoringSafeArea(.all)
                
                HStack(spacing: 100) {
                    OnboardingControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                    
                    Spacer()
                    
                    if (currentPageIndex != 2) {
                        Button(action: {
                            if self.currentPageIndex+1 == self.subviews.count {
                                self.currentPageIndex = 0
                            } else {
                                self.currentPageIndex += 1
                            }
                        }){
                            Image(systemName: K.Icon.ArrowRight)
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15)
                                .padding()
                                .background(Color.primaryColor)
                                .cornerRadius(30)
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 50))
                    }
                    
                    if (currentPageIndex == 2) {
                        Button(action: {
                            let preferences = UserDefaults.standard
                            preferences.set("Onboarding", forKey: "Onboarding")
                            isPresenting.toggle()
                        }){
                            Image(K.System.Icon)
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(8.5)
                                .background(Color.primaryColor)
                                .cornerRadius(30)
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 50))
                        .fullScreenCover(isPresented: $isPresenting) {
                            LoginWrapperView()
                        }
                    }
                }
            }
            .background(Color.black)
    }
}
