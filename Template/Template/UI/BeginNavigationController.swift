//
//  BeginNavigationController.swift
//  Template
//
//  Created by Topkim on 2020/04/11.
//  Copyright © 2020 Top Kim. All rights reserved.
//

import UIKit

class BeginNavigationController: BaseNavigationController {
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootController = SearchViewController(
            inputData: SearchViewModel.InputData()
        )
        
        viewControllers = [rootController]
    }
}
