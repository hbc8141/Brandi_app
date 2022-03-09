//
//  FullImageModuleViewModel.swift
//  brandi
//
//  Created by User on 2022/03/09.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

class FullImageModuleViewModel {
    
    // MARK: - Properties
    // 선택한 아이템 정보
    let selectSearchImageOb:BehaviorRelay<SearchImage?> = BehaviorRelay<SearchImage?>(value: nil)
    
    // 선택한 이미지
    let imageOb:BehaviorSubject<KFCrossPlatformImage> = BehaviorSubject<KFCrossPlatformImage>(value: UIImage())
    
    // 스크롤뷰의 크기와 컨텐츠 크기 지정을 위한 Observable
    let imageRectOb:BehaviorSubject<CGRect> = BehaviorSubject<CGRect>(value: CGRect())
    
    // 선택한 아이템 출처
    let docUrlOb:BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    // 선택한 아이템 생성시간
    let dateTimeOb:BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    let disposeBag:DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    init() {
        // 출처 대입
        let selectSearchImageOb = self.selectSearchImageOb.flatMap { (searchImage:SearchImage?) -> Observable<SearchImage> in
            guard let searchImage:SearchImage = searchImage else { return .empty() }
            
            return .just(searchImage)
        }
        
        // 출처 바인딩
        selectSearchImageOb.map { $0.doc_url }
            .bind(to: self.docUrlOb)
            .disposed(by: self.disposeBag)

        // 날짜 대입
        selectSearchImageOb.map { $0.datetime }
            .bind(to: self.dateTimeOb)
            .disposed(by: self.disposeBag)
        
        // 전체 이미지 Observable
        selectSearchImageOb
            .flatMap({ (searchImage:SearchImage?) -> Observable<URL> in
                guard let searchImage:SearchImage = searchImage else {
                    return .empty()
                }

                guard let url:URL = URL(string: searchImage.image_url) else {
                    return .empty()
                }

                return .just(url)
            })
            .flatMapLatest {
                KingfisherManager.shared.rx.retrieveImage(with: $0)
            }
            .observe(on: MainScheduler.instance)
            .bind(to: self.imageOb)
            .disposed(by: self.disposeBag)
        
        // 이미지 크기 Observable
        self.imageOb
            .map { CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: $0.size.height + 50) }
            .bind(to: self.imageRectOb)
            .disposed(by: self.disposeBag)
    }
}
