//
//  DetailViewController.swift
//  Template
//
//  Created by Topkim on 2022/01/19.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailViewController: BaseViewController {

    // MARK: - Init

    init(inputData: ViewModel.InputData) {
        self.inputData = inputData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Interface Builder Links

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    // MARK: - Internal Property
    
    typealias ViewModel = DetailViewModel
    
    private var viewModel: ViewModel!
    private var disposeBag = DisposeBag()

    private var inputData: ViewModel.InputData
   
    
    // MARK: - Life Cycles.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
        
        initViewBinding()
        
        viewModel.initViewModel(inputData: inputData)

    }
    
    
    // MARK: - Routing

    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UI Binding
    
    private func initViewBinding() {
        
        // Input
        
        closeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss()
            })
            .disposed(by: disposeBag)

        
        // Output
        
        viewModel
            .isLoadingObservable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isLoading in
                Log.d("isLoadingObservable: \(isLoading)")
                isLoading ? DialogFactory.showLoading() : DialogFactory.hideLoading()
            })
            .disposed(by: disposeBag)
        
        
        viewModel
            .errorObservable
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] it in
                Log.d("errorObservable: \(it)")
                guard let `self` = self else { return }
                DialogFactory.showAlert(
                    vc: self,
                    title: "오류",
                    message: it
                )
            })
            .disposed(by: disposeBag)
        
        viewModel
            .imageForViewObservable
            .asDriver(onErrorJustReturn: ViewModel.ImageForView(title: "", image: UIImage(), createdAt: ""))
            .drive(onNext: { [weak self] it in
                Log.d("imageForViewObservable : \(it)")
                guard let `self` = self else { return }
                self.titleImageView.image = it.image
                self.titleLabel.text = it.title
                self.createdAtLabel.text = it.createdAt
            })
            .disposed(by: disposeBag)
        
    }
}
