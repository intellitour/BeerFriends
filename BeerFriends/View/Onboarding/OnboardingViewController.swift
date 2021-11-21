//
//  OnboardingViewController.swift
//  BeerFriends
//
//  Created by Wesley Marra on 20/11/21.
//

import Foundation
import UIKit
import SwiftUI

struct OnboardingViewController: UIViewControllerRepresentable {
     
    var viewControllers: [UIViewController]
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let onboardingViewController = UIPageViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal)
        
        onboardingViewController.dataSource = context.coordinator

        return onboardingViewController
    }
    
    func updateUIViewController(_ onboardingViewController: UIPageViewController, context: Context) {
        onboardingViewController.setViewControllers(
                [viewControllers[0]], direction: .forward, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource {
        var parent: OnboardingViewController

        init(_ onboardingViewController: OnboardingViewController) {
            self.parent = onboardingViewController
        }
        
        func pageViewController(_ onboardingViewController: UIPageViewController,
                viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.viewControllers.last
            }
            return parent.viewControllers[index - 1]
        }
        
        func pageViewController(_ onboardingViewController: UIPageViewController,
                viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            guard let index = parent.viewControllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.viewControllers.count {
                return parent.viewControllers.first
            }
            return parent.viewControllers[index + 1]
        }
    }
}
