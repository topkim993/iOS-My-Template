//
//  SearchViewModel.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//

import Foundation
import RxSwift

class SearchViewModel {
  
    // MARK: - Define

    struct InputData {
        
    }
    
    struct ImageForModel {
        let gifImageInfo: GifImageInfo
        let title: String
        let imageUrl: String
    }

    struct ImageForView {
        let title: String
        let imageUrl: String
    }
    
    
    // MARK: - INTERNAL Property

    private var disposeBag = DisposeBag()
    private var isDisposed = false

    private var inputData: InputData!
    
    private let gifsDomain = GifsDomain()
    
    private let limit = 24
    private var offset = 0
    
    private var currentImageForModelList = [ImageForModel]()
    
    private let refreshSubject = BehaviorSubject<Void>(value: Void())
    private let fetchMoreSubject = BehaviorSubject<Void>(value: Void())
    
    private let searchQuerySubject = BehaviorSubject<String>(value: "")
    
    
    // MARK: - UI Binding Property

    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    var isLoadingObservable: Observable<Bool> {
        return isLoadingSubject.asObservable()
    }
    private let errorSubject = PublishSubject<String>()
    var errorObservable: Observable<String> {
        return errorSubject.asObservable()
    }
    private let newSearchedSubject = PublishSubject<Void>()
    var newSearchedObservable: Observable<Void> {
        return newSearchedSubject.asObservable()
    }
    private let imageForViewListSubject = BehaviorSubject<[ImageForView]>(value: [])
    var imageForViewListObservable: Observable<[ImageForView]> {
        return imageForViewListSubject.asObservable()
    }
    private let selectedImageForModelSubject = PublishSubject<ImageForModel>()
    var selectedImageForModelObservable: Observable<ImageForModel> {
        return selectedImageForModelSubject.asObservable()
    }
    
    // MARK: - Public Functions
    
    func initViewModel(inputData: InputData) {
        self.inputData = inputData
        initLogic()
    }
    
    func newSearch(query: String) {
        searchQuerySubject.onNext(query)
    }
    
    func refresh() {
        reInitLogicIfError()
        refreshSubject.onNext(Void())
    }
    
    func fetchMore() {
        reInitLogicIfError()
        fetchMoreSubject.onNext(Void())
    }
    
    func selectImageForModel(index: Int) {
        selectedImageForModelSubject.onNext(
            currentImageForModelList[index]
        )
    }
    
    
    // MARK: - Private Function
    
    private func initLogic() {
        initFetchLogic()
    }
    
    private func reInitLogicIfError() {
        if isDisposed {
            isDisposed = false
            initLogic()
        }
    }
    
    private func initFetchLogic() {
        let newSearchOb = Observable
            .combineLatest(searchQuerySubject, refreshSubject)
            .do(onNext: { _ in self.isLoadingSubject.onNext(true)})
            .map{ $0.0 }
            .do(onNext: { _ in
                if self.currentImageForModelList.count > 0 {
                    self.newSearchedSubject.onNext(Void())
                }
                self.offset = 0
            })
            .flatMap {
                self.fetchGIFsOb(query: $0)
            }
            .do(onNext: { _ in
                self.currentImageForModelList = []
            })
                
        let fetchMoreOb = fetchMoreSubject
            .withLatestFrom(searchQuerySubject, resultSelector: {$1})
            .do(onNext: { _ in self.isLoadingSubject.onNext(true)})
            .flatMap {
                self.fetchGIFsOb(query: $0)
            }
    
        Observable.merge(newSearchOb, fetchMoreOb)
            .map{
                $0.data.map{ it -> ImageForModel in
                    let gifImageInfo = it
                    let title = it.title
                    let imageUrl = it.images.fixedHeightDownsampled.url
                    return ImageForModel(
                        gifImageInfo: gifImageInfo,
                        title: title,
                        imageUrl: imageUrl
                    )
                }
            }
            .map{ it -> [ImageForModel] in
                if !it.isEmpty { self.offset = self.offset + it.count }
                return self.currentImageForModelList + it
            }
            .do(onNext: {
                self.currentImageForModelList = $0
            })
            .map{
                $0.map{ it -> ImageForView in
                    let title = it.title
                    let imageUrl = it.imageUrl
                    return ImageForView(
                        title: title,
                        imageUrl: imageUrl
                    )
                }
            }
            .subscribe(
                onNext: { [weak self] result in
                    guard let `self` = self else { return }
                    self.isLoadingSubject.onNext(false)
                    self.imageForViewListSubject.onNext(result)
                },
                onError: {[weak self]  error in
                    guard let `self` = self else { return }
                    Log.e("error : \(error)")
                    self.isLoadingSubject.onNext(false)
                    self.errorSubject.onNext(error.localizedDescription)
                    self.isDisposed = true
                    self.disposeBag = DisposeBag()
                }
            )
            .disposed(by: disposeBag)
        
    }
  
    private func fetchGIFsOb(query: String) -> Observable<GifSearchResponse> {
        return Observable
            .just(query)
            .flatMap{ query -> Observable<GifSearchResponse> in
                if query.isEmpty {
                    return self.gifsDomain.fetchTrendingGIFs(
                        offset: self.offset,
                        limit: self.limit
                    )
                }
                else {
                    return self.gifsDomain.fetchGIFs(
                        query: query,
                        offset: self.offset,
                        limit: self.limit
                    )
                }
            }
            .do(onNext: { it in
                guard it.meta.status == 200 else {
                    throw NSError(
                        domain: it.meta.msg,
                        code: it.meta.status,
                        userInfo: [NSLocalizedDescriptionKey : it.meta.msg]
                    )
                }
            })
    }
}
