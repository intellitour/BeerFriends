//
//  AnimatedView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 01/12/21.
//

import SwiftUI
import Lottie

struct AnimatedView: UIViewRepresentable {
    @Binding var show: Bool
    @Binding var showPackBeerImage: Bool
    
    func makeUIView(context: Context) -> AnimationView {
        let view = AnimationView(name: K.Login.PackBeer, bundle: Bundle.main)
        view.play { (status) in
           if status {
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                    show.toggle()
                    showPackBeerImage.toggle()
                }
            }
        }
       
        return view
    }
    
    func updateUIView(_ uiView: AnimationView, context: Context) { }
}
