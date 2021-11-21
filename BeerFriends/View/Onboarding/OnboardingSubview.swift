//
//  OnboardingSubview.swift
//  BeerFriends
//
//  Created by Wesley Marra on 18/11/21.
//

import SwiftUI

struct OnboardingSubview: View {
    
    var imageName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(K.Omboarding.Icon)
                        .padding(.bottom, 10)

                    Text(title)
                        .font(.largeTitle)
                        .foregroundColor(.primaryColor)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .foregroundColor(.primaryColor)
                        .frame(maxWidth: 320)
                        .padding(.top, 20)
                        .padding(.bottom, 160)
                }
            }
        }
    }
}

struct OnboardingSubview_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSubview(
            imageName: K.Omboarding.ImageOne,
            title: K.Omboarding.TitleOne,
            subtitle: K.Omboarding.SubtitleOne)
    }
}
