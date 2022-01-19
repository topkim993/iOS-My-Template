//
//  UIViewControllerExtension.swift
//  Template
//
//  Created by Topkim on 2020/11/29.
//

import UIKit

extension UIViewController {

    static func getTopViewController () -> UIViewController? {
        let window = UIApplication.shared.windows.first!
        return UIWindow.topViewController(window)()
    }
    

    static func addChildViewController(containerView: UIView, parentVC: UIViewController, childVC: UIViewController) {
        let controller = childVC
    
        parentVC.addChild(controller)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        controller.didMove(toParent: parentVC.self)
    }
    
    static func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    

}
