//
//  OnboardingControl.swift
//  BeerFriends
//
//  Created by Wesley Marra on 21/11/21.
//

import Foundation
import UIKit
import SwiftUI

struct OnboardingControl: UIViewRepresentable {
    
    var numberOfPages: Int
        
    @Binding
    var currentPageIndex: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
            control.numberOfPages = numberOfPages
            control.currentPageIndicatorTintColor = UIColor.orange
            control.pageIndicatorTintColor = UIColor.gray

        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
}
