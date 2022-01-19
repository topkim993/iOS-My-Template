//
//  SearchViewController.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//


import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {

    // MARK: - Init

    init(inputData: ViewModel.InputData) {
        self.inputData = inputData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constant
    
    private typealias Cell = SearchImageCollectionViewCell
    
    
    // MARK: - Interface Builder Links

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    
    // MARK: - Internal Property
    
    typealias ViewModel = SearchViewModel
    
    private var viewModel: ViewModel!
    private var disposeBag = DisposeBag()

    private var inputData: ViewModel.InputData
    
    private var cellCount = 3
    private var cellSpacing: CGFloat = 1

    
    // MARK: - Life Cycles.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()

        initGridView()
        
        initViewBinding()
        
        viewModel.initViewModel(inputData: inputData)

    }
    
    
    // MARK: - Routing

    private func presentDetailViewController(inputData: DetailViewModel.InputData){
        let vc = DetailViewController(inputData: inputData)
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - UI Binding
    
    private func initViewBinding() {
        
        // Input
        
        searchBar.rx.text
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let `self` = self else { return }
                self.viewModel.newSearch(query: text ?? "")
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                self.viewModel.selectImageForModel(
                    index: indexPath.row
                )
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems
            .withLatestFrom(
                viewModel.imageForViewListObservable
            ){($0, $1)}
            .filter{ (indexPaths, list) in
                let dataCount = list.count
                return indexPaths
                    .filter{ indexPath in
                        dataCount - 1 == indexPath.row
                    }
                    .isEmpty == false
            }
            .map{ _ in
                Void()
            }
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self]  in
                guard let `self` = self else { return }
                self.viewModel.fetchMore()
            })
            .disposed(by: disposeBag)
               
        Observable
            .merge(
                searchBar.rx.delegate
                    .sentMessage(#selector(UISearchBarDelegate.searchBarSearchButtonClicked(_:))),
                collectionView.rx.delegate
                    .sentMessage(#selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:)))
            )
            .subscribe(onNext: { _ in
                self.view.endEditing(true)
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
            .newSearchedObservable
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] it in
                Log.d("newSearchedObservable : \(it)")
                guard let `self` = self else { return }
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .imageForViewListObservable
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: String(describing: Cell.self), cellType: Cell.self)
                ) { index, item, cell in
                cell.imgUrl = item.imageUrl
            }
            .disposed(by: disposeBag)
        
        viewModel
            .selectedImageForModelObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] it in
                Log.d("selectedImageForModelObservable : \(it)")
                guard let `self` = self else { return }
                self.presentDetailViewController(
                    inputData: DetailViewModel.InputData(
                        gifImageInfo: it.gifImageInfo
                    )
                )
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func initGridView() {
        let cellId = String(describing: Cell.self)
        
        self.collectionView.register(
            UINib(nibName: cellId, bundle: nil),
            forCellWithReuseIdentifier: cellId
        )
        self.collectionView.delegate = self
        
        guard let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flow.minimumInteritemSpacing = CGFloat(self.cellSpacing)
        flow.minimumLineSpacing = CGFloat(self.cellSpacing)
        
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
    }
    
    func calculateWith() -> CGFloat {
        let collectionViewWidth = self.collectionView.frame.size.width
        
        let summedHorizontalSpacing = cellSpacing * CGFloat(cellCount - 1)
        
        let width = (collectionViewWidth - summedHorizontalSpacing)  / CGFloat(cellCount)
        
        return width
    }
}
