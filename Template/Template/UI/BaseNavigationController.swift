//
//  BaseNavigationController.swift
//  Template
//
//  Created by Topkim on 2020/04/11.
//  Copyright © 2020 Top Kim. All rights reserved.
//
//

import UIKit

class BaseNavigationController: UINavigationController {

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBarTheme()
        setSwipeBackGestureWhenHiddenNavBar()
        isNavigationBarHidden = true
    }
    
    //MARK: -ETC functions
    
    /// Navigation Bar 투명으로 만듬.
    private func initNavigationBarTheme(){
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
    }
    
    /// 네비게이션 바 숨김 시 스와이프 시 뒤로가기 애니메이션 동작하도록 설정.
    private func setSwipeBackGestureWhenHiddenNavBar(){
        interactivePopGestureRecognizer?.delegate = self
    }
    
    /// 스와이프 백 제스처 사용 여부 설정.
    func setPopGestureRecognizerEnable(isEnable: Bool){
        interactivePopGestureRecognizer?.isEnabled = isEnable
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate{
    
    /// 네비게이션 스택 두개 이상 일 때 스와이프 백 동작 하도록 설정.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
