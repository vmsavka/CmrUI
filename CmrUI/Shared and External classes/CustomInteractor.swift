//
//  CustomInteractor.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/16/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

class CustomInteractor : UIPercentDrivenInteractiveTransition {
    
    var navigationController : UINavigationController
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    init?(attachTo viewController : UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            setupBackGesture(view: viewController.view)
        } else {
            return nil
        }
    }
    
    private func setupBackGesture(view : UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.x / self.navigationController.view.frame.width
        
        switch gesture.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
            break
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            break
        case .cancelled:
            transitionInProgress = false
            cancel()
            break
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
        default:
            return
        }
    }
}
