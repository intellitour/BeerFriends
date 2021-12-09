//
//  LoginView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 02/12/21.
//

import SwiftUI
import Lottie

struct LoginWrapperView: View {
    @State private var forgotPassawordFlipped = false
    @State private var signUpFlipped = false
    @State private var animateForgotPassaword = false
    @State private var animateSignUp = false
    
    @State var showCard = false
    @State var showPackBeerImage = false

    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel

    var body: some View {
        VStack {
            ZStack {
                Color(uiColor: UIColor(.primaryColor)).ignoresSafeArea()
                VStack(alignment: .leading) {
                    Spacer()
                    if !showPackBeerImage {
                        AnimatedView(showCard: $showCard, showPackBeerImage: $showPackBeerImage)
                            .frame(height: UIScreen.main.bounds.height)
                            .padding(.top, 170)
                    } else {
                        Image(K.Login.SignInImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, alignment: .top)
                    }

                    ZStack {
                        SignInView(showCard: $showCard,
                                   showPackBeerImage: $showPackBeerImage,
                                   animateForgotPassaword: $animateForgotPassaword,
                                   animateSignUp: $animateSignUp)
                            .opacity(forgotPassawordFlipped ? 0.0 : 1.0)
                        
                        ForgotPassawordView(animate3d: $animateForgotPassaword)
                            .opacity(forgotPassawordFlipped ? 1.0 : 0.0)
                        
                        SignUPView(animate3d: $animateSignUp)
                            .opacity(signUpFlipped ? 1.0 : 0.0)
                    }
                    .modifier(FlipEffect(flipped: $forgotPassawordFlipped,
                                         angle: animateForgotPassaword ? 180 : 0, axis: (x: 0, y: 1)))
                    .modifier(FlipEffect(flipped: $signUpFlipped,
                                         angle: animateSignUp ? 180 : 0, axis: (x: 0, y: 1)))
                }
            }
        }
        .environmentObject(userSessionStoreViewModel)
    }
}


struct AnimatedView: UIViewRepresentable {
    @Binding var showCard: Bool
    @Binding var showPackBeerImage: Bool
    
    func makeUIView(context: Context) -> AnimationView {
        let view = AnimationView(name: K.Login.PackBeer, bundle: Bundle.main)
        view.play { (status) in
           if status {
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                    showCard.toggle()
                    showPackBeerImage.toggle()
                }
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: AnimationView, context: Context) { }
}


struct FlipEffect: GeometryEffect {

    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)

    func effectValue(size: CGSize) -> ProjectionTransform {

        DispatchQueue.main.async {
              self.flipped = self.angle >= 90 && self.angle < 270
        }

        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)

        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)

        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}
