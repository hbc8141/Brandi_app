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
    // 검색 바
    private let searchBar:BaseSearchBar = BaseSearchBar()

    // 검색하여 반환된 이미지 표시
    private let searchResultCollectionView:BaseCollectionView = BaseCollectionView(cellClass: SearchModuleCell.self, forCellWithReuseIdentifier: "cell")

    // 결과값이 없을 경우 결과값 없음 반환ㄴ
    private let notResultLabel:BaseLabel = BaseLabel(title: "결과가 없습니다.", textAlignment: .center)

    // ViewModel
    private let viewModel:SearchModuleViewModel = SearchModuleViewModel()
    
    private let startLoadingOffset: CGFloat = 10.0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.notResultLabel.isHidden = true

        // 네비게이션 바 숨김
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.view.addSubViews([
            self.searchBar,
            self.searchResultCollectionView,
            self.notResultLabel
        ])

        self.setupLayouts()
        self.bindUI()
    }

    // MARK: - Function
    override func bindUI() {
        // 검색어를 ViewModel과 바인딩
        self.searchBar.rx.text.orEmpty
            // 무분별한 입력 방지
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            // 입력 완료 1초 뒤 반응
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: self.viewModel.searchQuery)
            .disposed(by: self.disposeBag)
        
        // Delegate 설정
        self.searchResultCollectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        // 결과값이 없을 경우 결과값 없음 표시
        self.viewModel.notResultOb
            .bind(to: self.notResultLabel.rx.isHidden)
            .disposed(by: self.disposeBag)

        // 결과값이 있을 경우 collectionView에 표시
        self.viewModel.searchImages.bind(to: self.searchResultCollectionView.rx.items(cellIdentifier: "cell", cellType: SearchModuleCell.self)) { (row:Int, searchImage:SearchImage, cell:SearchModuleCell) in
            cell.document = searchImage
        }
        .disposed(by: self.disposeBag)

        // 아이템 선택 시 이미지 전체화면 페이지로 이동
        self.searchResultCollectionView.rx.modelSelected(SearchImage.self)
            .bind(onNext: { (image:SearchImage) in
                let fullImageController:FullImageModuleController = FullImageModuleController(searchImage: image)
                
                // iOS 13 이후 버전에서는 카드형식으로 표시되므로 전체화면으로 변경
                fullImageController.modalTransitionStyle = .crossDissolve
                fullImageController.modalPresentationStyle = .overFullScreen
                
                self.present(fullImageController, animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        // 스크롤 시 키보드 숨기기
        self.searchResultCollectionView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                if self.searchBar.isFirstResponder {
                    self.searchBar.resignFirstResponder()
                }
            }).disposed(by: self.disposeBag)
        
        let pageOb = self.searchResultCollectionView.rx.contentOffset
            .flatMap({ (point:CGPoint) -> Observable<Bool> in
                // 하단부 이상의 스크롤 여부 확인
                let isBottom = Utils.shared.isNearBottomEdge(offset: point, collectionView: self.searchResultCollectionView)

                return .just(isBottom)
            })
            .withLatestFrom(self.viewModel.isLoadingOb) { ($0, $1) }

        pageOb.flatMapLatest { (isBottom:Bool, isLoading:Bool) -> Observable<Bool> in
            // 로딩 전 지속적인 스크롤을 하여 무한 로딩 상황 방지
            if !isBottom {
                return .empty()
            }
        
            return .just(true)
        }
        .bind(to: self.viewModel.isLoadingOb)
        .disposed(by: self.disposeBag)
            
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

