//
//  OnboardingSubview.swift
//  BeerFriends
//
//  Created by Wesley Marra on 18/11/21.
//

import SwiftUI

struct OnboardingSubview: View {
    
    var imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if imageName == K.Omboarding.ImageOne {
                        Image(K.Omboarding.Icon)
                            .padding(.bottom, 10)
                        
                        Text(K.Omboarding.Title)
                            .font(.largeTitle)
                            .foregroundColor(.primaryColor)
                            .multilineTextAlignment(.center)
                        
                        Text(K.Omboarding.Subtitle)
                            .foregroundColor(.primaryColor)
                            .frame(maxWidth: 320)
                            .padding(.top, 20)
                            .padding(.bottom, 160)
                    }
                }
            }
        }
    }
}
