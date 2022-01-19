//
//  DetailViewModel.swift
//  Template
//
//  Created by Topkim on 2022/01/19.
//


import Foundation
import RxSwift
import Kingfisher

class DetailViewModel {
  
    // MARK: - Define

    struct InputData {
        let gifImageInfo: GifImageInfo
    }
    
    struct ImageForModel {
        let title: String
        let image: UIImage
        let createdAt: Date
    }

    struct ImageForView {
        let title: String
        let image: UIImage
        let createdAt: String
    }
    
    
    // MARK: - INTERNAL Property

    private var disposeBag = DisposeBag()
    private var isDisposed = false

    private var inputData: InputData!
    
    private let refreshSubject = BehaviorSubject<Void>(value: Void())
    
    
    // MARK: - UI Binding Property

    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    var isLoadingObservable: Observable<Bool> {
        return isLoadingSubject.asObservable()
    }
    private let errorSubject = PublishSubject<String>()
    var errorObservable: Observable<String> {
        return errorSubject.asObservable()
    }
    private let imageForViewSubject = BehaviorSubject<ImageForView>(
        value: ImageForView(
            title: "",
            image: UIImage(),
            createdAt: ""
        )
    )
    var imageForViewObservable: Observable<ImageForView> {
        return imageForViewSubject.asObservable()
    }
    
    // MARK: - Public Functions
    
    func initViewModel(inputData: InputData) {
        self.inputData = inputData
        initLogic()
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
        let imageForModelSubject = PublishSubject<ImageForModel>()
        
        imageForModelSubject
            .map{ it -> ImageForView in
                let title = it.title
                let image = it.image
                let createdAt = it.createdAt.formatting(format: "yy-MM-dd")
                return ImageForView(
                    title: title,
                    image: image,
                    createdAt: createdAt
                )
            }
            .subscribe(
                onNext: { [weak self] result in
                    guard let `self` = self else { return }
                    self.isLoadingSubject.onNext(false)
                    self.imageForViewSubject.onNext(result)
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
        
        refreshSubject
            .flatMap{ _ in
                self.fetchImageOb(
                    url: self.inputData.gifImageInfo.images.fixedHeightDownsampled.url
                )
            }
            .map{ image -> ImageForModel in
                let it = self.inputData.gifImageInfo
                let title = it.title
                let downSampledImage = image
                let createdAt = it.createAt?.toDateByISO8601() ?? Date()
                return ImageForModel(
                    title: title,
                    image: downSampledImage,
                    createdAt: createdAt
                )
            }
            .do(onNext: {
                imageForModelSubject.onNext($0)
            })
            .flatMap{ _ in
                self.fetchImageOb(
                    url: self.inputData.gifImageInfo.images.original.url
                )
            }
            .map{ image -> ImageForModel in
                let it = self.inputData.gifImageInfo
                let title = it.title
                let orignImage = image
                let createdAt = it.createAt?.toDateByISO8601() ?? Date()
                return ImageForModel(
                    title: title,
                    image: orignImage,
                    createdAt: createdAt
                )
            }
            .subscribe(
                onNext: { result in
                    imageForModelSubject.onNext(result)
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
    

    private func fetchImageOb(
        url: String
    ) -> Observable<UIImage> {
        Observable.create{ emitter in
            KingfisherManager.shared.retrieveImage(
                with: URL(string: url)!,
                options: [],
                completionHandler:{ result in
                    switch result {
                    case .success(let data):
                        emitter.onNext(data.image)
                        emitter.onCompleted()
                    case .failure(let error):
                        emitter.onError(error)
                    }
                }
            )
            return Disposables.create()
        }
    }
}
