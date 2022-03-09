//
//  SearchModuleController.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import UIKit
import RxSwift
import RxCocoa

class SearchModuleController: BaseController {
    
    // MARK: - Properties
    private let searchBar:BaseSearchBar = BaseSearchBar()

    private let searchResultCollectionView:BaseCollectionView = BaseCollectionView(cellClass: SearchModuleCell.self, forCellWithReuseIdentifier: "cell")

    private let notResultLabel:BaseLabel = BaseLabel(title: "결과가 없습니다.", textAlignment: .center)
    
    private var searchImages:BehaviorSubject<[SearchImage]> = BehaviorSubject<[SearchImage]>(value: [])

    private let apiService:ApiService = ApiService()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notResultLabel.isHidden = true
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.searchResultCollectionView)
        self.view.addSubview(self.notResultLabel)

        self.setupLayouts()
        self.bindUI()
    }

    // MARK: - Function
    override func bindUI() {
        let searchResult = self.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { (query:String) -> Observable<Document?> in
                if query.isEmpty {
                    return .just(nil)
                }

                let request:ImageSearchRequest = ImageSearchRequest(query: query)

                let response:Observable<Document?> = self.apiService.request(apiRequest: request)

                return response
            }
            .flatMap({ (document:Document?) -> Observable<[SearchImage]> in
                guard let document:Document = document else {
                    return .just([])
                }
                
                guard let images:[SearchImage] = document.documents else {
                    return .just([])
                }
                
                return .just(images)
            })
            .observe(on: MainScheduler.instance)
            .share()
        
        searchResult.bind(to: self.searchImages)
            .disposed(by: self.disposeBag)
        
        // 결과값이 없을 경우 결과값 없음 표시
        self.searchImages.map { $0.count == 0 ? false : true }
            .bind(to: self.notResultLabel.rx.isHidden)
            .disposed(by: self.disposeBag)

        // 결과값이 있을 경우 collectionView에 표시
        self.searchImages.bind(to: self.searchResultCollectionView.rx.items(cellIdentifier: "cell", cellType: SearchModuleCell.self)) { (row:Int, searchImage:SearchImage, cell:SearchModuleCell) in
            cell.document = searchImage
        }
        .disposed(by: self.disposeBag)

        self.searchResultCollectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)

        // 아이템 선택 시
        self.searchResultCollectionView.rx.modelSelected(SearchImage.self)
            .bind(onNext: { (image:SearchImage) in
                let fullImageController:FullImageModuleController = FullImageModuleController(searchImage: image)
                
                self.pushViewController(fullImageController)
            }).disposed(by: self.disposeBag)

        self.searchResultCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(onNext: { (row:Int) in

            }).disposed(by: self.disposeBag)
    }
    
    override func setupLayouts() {
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            self.searchResultCollectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            self.searchResultCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.searchResultCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.searchResultCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.notResultLabel.topAnchor.constraint(equalTo: self.searchBar.safeAreaLayoutGuide.bottomAnchor),
            self.notResultLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.notResultLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.notResultLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

