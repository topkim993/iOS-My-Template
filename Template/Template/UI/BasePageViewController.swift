//
//  BasePageViewController.swift
//  Template
//
//  Created by jeong on 2020/12/24.
//


import UIKit

class BasePageViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{

    var pages = [UIViewController]()
    
    var onChangedCurrentPage: ((Int) -> Void)?
    
    // Track the current index
    var currentIndex: Int?
    
    
    private var pendingIndex: Int?
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
    }
    
    func setPage(index: Int) {
        guard pages.count > 0 else {
            return
        }
        
        guard pages.count > index else {
            setViewControllers([pages.first!], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
            return
        }
        
        setViewControllers([pages[index]], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
    
    func setPage(index: Int, animated: Bool) {
        guard pages.count > 0 else {
            return
        }
        
        guard pages.count > index else {
            setViewControllers([pages.first!], direction: UIPageViewController.NavigationDirection.forward, animated: animated, completion: nil)
            return
        }
        
        setViewControllers([pages[index]], direction: UIPageViewController.NavigationDirection.forward, animated: animated, completion: nil)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        let cur = pages.firstIndex(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        if cur == 0 { return nil }
        
        var prev = (cur - 1) % pages.count
        
        if prev < 0 {
            prev = pages.count - 1
        }
        
        return pages[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        let cur = pages.firstIndex(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        if cur == (pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)
        
        return pages[nxt]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        let currentPage = pages.firstIndex(of: pageContentViewController)!
        onChangedCurrentPage?(currentPage)
    }
    
    
    var isPagingEnabled: Bool {
            get {
                var isEnabled: Bool = true
                for view in view.subviews {
                    if let subView = view as? UIScrollView {
                        isEnabled = subView.isScrollEnabled
                    }
                }
                return isEnabled
            }
            set {
                for view in view.subviews {
                    if let subView = view as? UIScrollView {
                        subView.isScrollEnabled = newValue
                    }
                }
            }
        }
}
