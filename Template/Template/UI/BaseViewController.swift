//
//  BaseViewController.swift
//  Template
//
//  Created by Topkim on 2020/04/09.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK: - Property
    
    private var disposeBag = DisposeBag()
    
    private var keyboardShownWithSizeSubject = PublishSubject<CGSize>()
    var keyboardShownWithSizeOb: Observable<CGSize> {
        return keyboardShownWithSizeSubject.asObservable()
    }
    
    private var keyboardHiddenSubject = PublishSubject<Bool>()
    var keyboardHiddenOb: Observable<Bool> {
        return keyboardHiddenSubject.asObservable()
    }
    
    
    //MARK: - LifeCycle
    
    /// 뷰가 화면에 표시 직전 호출.
    /// - Parameter animated: 애니메이션 여부.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initKeyboardNotification()
        
    }
    
    /// 뷰가 화면에서 사라지기 직전 호출.
    /// - Parameter animated: 애니메이션 여부.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitKeyboardNotification()
    }
    
    
    // MARK: - Routing
    
    
    
    //MARK: - Event Hadling
    
    
    /// 키보드 올라온 경우 처리.
    @objc func shownKeyBoard(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyBoardSize = rect.size
        keyboardShownWithSizeSubject.onNext(keyBoardSize)
    }
    
    /// 키보드 내려간 경우 처리.
    @objc func hiddenKeyBoard(_ notification: NSNotification) {
        keyboardHiddenSubject.onNext(true)
    }
    
    
    //MARK: - Custon Functions
    
    /// 키보드 Listener 등록.
    private func initKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.shownKeyBoard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hiddenKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 키보드 Listener 등록 해지.
    private func deinitKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    /// 자기 자신을 반환.
    /// - Parameter value: 받은 값.
    /// - Returns: 자기 자신.
    func itself<T>(_ value: T) -> T {
        return value
    }
 
}




