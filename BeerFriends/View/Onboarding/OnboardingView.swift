//
//  OnboardingView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 18/11/21.
//

import SwiftUI

struct OnboardingView: View {
    
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
            OnboardingViewController(viewControllers: subviews)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
