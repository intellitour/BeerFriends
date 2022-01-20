//
//  OnboardingSubview.swift
//  BeerFriends
//
//  Created by Wesley Marra on 18/11/21.
//

import SwiftUI

struct OnboardingSubview: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                if imageName == K.Omboarding.ImageOne {
                    VStack {
                            Image(K.System.Icon)
                                .padding(.bottom, 10)
                            
                            Text(K.Omboarding.Title)
                            .font(.custom(K.Fonts.Papyrus, size: 30))
                                .foregroundColor(colorScheme == .dark ? .secondaryColor : .primaryColor)
                                .multilineTextAlignment(.center)
                            
                            Text(K.Omboarding.Subtitle)
                                .foregroundColor(colorScheme == .dark ? .secondaryColor : .primaryColor)
                                .frame(maxWidth: 320)
                                .padding(.top, 20)
                                .padding(.bottom, 160)
                                .font(.custom(K.Fonts.GillSans, size: 18))
                    }
                }
                
                if imageName == K.Omboarding.ImageTwo {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .center, spacing: 6) {
                            Text(K.Omboarding.SecondSubtitle)
                                .foregroundColor(colorScheme == .dark ? .secondaryColor : .primaryColor)
                                .frame(maxWidth: 100, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .font(.custom(K.Fonts.GillSans, size: 18))
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 80, leading: 40, bottom: 0, trailing: 0))
                        Spacer()
                    }
                }
                
                if imageName == K.Omboarding.ImageThree {
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(alignment: .top, spacing: 6) {
                            Spacer()
                            Text(K.Omboarding.FinalTitle)
                                .font(.custom(K.Fonts.GillSans, size: 30))
                                .foregroundColor(colorScheme == .dark ? .secondaryColor : .primaryColor)
                                .frame(maxWidth: 100, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(EdgeInsets(top: 80, leading: 40, bottom: 0, trailing: 0))
                        Spacer()
                    }
                }
            }
        }
    }
}
