//
//  SearchModuleViewModel.swift
//  brandi
//
//  Created by User on 2022/03/09.
//

import Foundation
import RxSwift
import RxCocoa

class SearchModuleViewModel {
    
    // MARK: - Properties
    // 검색어
    let searchQuery:BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    // 검색 결과
    let searchImages:BehaviorSubject<[SearchImage]> = BehaviorSubject<[SearchImage]>(value: [])
    
    // 검색 결과가 없을 시 결과 없음 표시 변수
    let notResultOb:BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: true)
    
    let isLoadingOb:BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)

    private var page:Int = 1
    
    // API 요청 클래스
    private let apiService:ApiService = ApiService()
    
    private let disposeBag:DisposeBag = DisposeBag()

    // MARK: - Function
    init() {
        self.fetchSearchImage()
        
        // 검색 결과값 존재 유무 바인딩
        self.searchImages.map { $0.count == 0 ? false : true }
            .bind(to: self.notResultOb)
            .disposed(by: self.disposeBag)
    }
    
    // 이미지 검색
    private func fetchSearchImage() -> Void {
        self.searchQuery
        .flatMapLatest { (query:String) ->  Observable<Document?> in
            // 검색 쿼리가 없을 경우 nil 반환
            if query.isEmpty {
                return .just(nil)
            }

            // 요청 및 반환
            let request:ImageSearchRequest = ImageSearchRequest(query: query, page: self.page)

            return self.apiService.request(apiRequest: request)
        }
        .flatMap({ (document:Document?) -> Observable<[SearchImage]> in
            // 요청 반환값이 없을 경우 빈 배열로 반환
            guard let document:Document = document else {
                return .just([])
            }
            
            // document가 없을 경우 빈 배열로 반환
            guard let images:[SearchImage] = document.documents else {
                return .just([])
            }
            
            return .just(images)
        })
        // 메인쓰레드로 전환
        .observe(on: MainScheduler.instance)
        .bind(to: self.searchImages)
        .disposed(by: self.disposeBag)
    }
}
