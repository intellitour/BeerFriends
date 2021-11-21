//
//  OnboardingView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 18/11/21.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var currentPageIndex = 0
    
    var subviews = [
            UIHostingController(rootView: OnboardingSubview(
                imageName: K.Omboarding.ImageOne,
                title: K.Omboarding.TitleOne,
                subtitle: K.Omboarding.SubtitleOne)),
            
            UIHostingController(rootView: OnboardingSubview(
                imageName: K.Omboarding.ImageTwo,
                title:  K.Omboarding.TitleTwo,
                subtitle:K.Omboarding.SubtitleTwo)),
            
            UIHostingController(rootView: OnboardingSubview(
                imageName: K.Omboarding.ImageThree,
                title: K.Omboarding.TitleThree,
                subtitle:K.Omboarding.SubtitleThree))
        ]
    
    var body: some View {
        VStack {
            OnboardingViewController(
                currentPageIndex: $currentPageIndex,
                viewControllers: subviews)
                .edgesIgnoringSafeArea(.all)
        HStack
            {
                OnboardingControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                
                Button(action: {
                    if self.currentPageIndex+1 == self.subviews.count {
                        self.currentPageIndex = 0
                    } else {
                        self.currentPageIndex += 1
                    }
                }){
                    Image(systemName: "arrow.right")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding()
                        .background(Color.primaryColor)
                        .cornerRadius(30)
                }
            }
        }
        .background(Color.black)
    }
}
