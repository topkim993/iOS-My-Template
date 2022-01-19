//
//  DialogFactory.swift
//  Template
//
//  Created by Topkim on 2020/11/29.
//

import UIKit

class DialogFactory {
    
    // MARK: - LoadingDialog
    
    private static var mLoadingView: UIView?
   
    private static var _isLoading: Bool = false
    
    static var isLoading: Bool {
        get {
            return _isLoading
        }
    }
    
    static func showLoading() {
        hideLoading()
        
        _isLoading = true
        
        let vc = UIViewController.getTopViewController()!
        
        let onView = vc.view!
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        
        let ai = UIActivityIndicatorView()
        ai.color = .gray
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            if mLoadingView == nil{
                spinnerView.addSubview(ai)
                onView.addSubview(spinnerView)
                
                ai.translatesAutoresizingMaskIntoConstraints = false
                ai.topAnchor.constraint(equalTo: spinnerView.topAnchor).isActive = true
                ai.bottomAnchor.constraint(equalTo: spinnerView.bottomAnchor).isActive = true
                ai.leadingAnchor.constraint(equalTo: spinnerView.leadingAnchor).isActive = true
                ai.trailingAnchor.constraint(equalTo: spinnerView.trailingAnchor).isActive = true
                
                spinnerView.translatesAutoresizingMaskIntoConstraints = false
                spinnerView.topAnchor.constraint(equalTo: onView.topAnchor).isActive = true
                spinnerView.bottomAnchor.constraint(equalTo: onView.bottomAnchor).isActive = true
                spinnerView.leadingAnchor.constraint(equalTo: onView.leadingAnchor).isActive = true
                spinnerView.trailingAnchor.constraint(equalTo: onView.trailingAnchor).isActive = true
                
                mLoadingView = spinnerView
            }
        }
    }
    
    static func hideLoading() {
        _isLoading = false
        DispatchQueue.main.async {
            self.mLoadingView?.removeFromSuperview()
            self.mLoadingView = nil
        }
    }
    
    static func showAlert(
        vc: UIViewController,
        title: String,
        message: String,
        onClickConfirm: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler : nil )
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
}
