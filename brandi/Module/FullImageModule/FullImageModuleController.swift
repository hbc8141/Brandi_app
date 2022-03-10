//
//  FullImageController.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import UIKit
import RxSwift
import Kingfisher

class FullImageModuleController: BaseController {
    
    // MARK: - Properties
    private let closeButton:BaseButton = BaseButton(title: "X")
    
    private lazy var imageScrollView:BaseScrollView = BaseScrollView()
    
    private let contentView:BaseView = BaseView()
    
    // 전체 이미지 뷰
    // Kingfisher 사용 시 내부 typealias에서 UIImageView를 가르키므로 업캐스팅 필요
    private let itemImageView:UIImageView = BaseImageView()
    
    // 출처 라벨
    private let displaySitenameLabel:BaseLabel = BaseLabel(textColor: .white, textAlignment: .center)
    
    // 등록날짜 라벨
    private let dateTimeLabel:BaseLabel = BaseLabel(textColor: .white, textAlignment: .center)
    
    // 뷰모델
    private let viewModel:FullImageModuleViewModel = FullImageModuleViewModel()

    // MARK: - Life Cycle
    init(searchImage: SearchImage) {
        super.init(nibName: nil, bundle: nil)

        Observable.of(searchImage)
            .bind(to: self.viewModel.selectSearchImageOb)
            .disposed(by: self.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        
        // 스크롤 뷰의 높이를 유동적으로 되게금 변경
        self.imageScrollView.autoresizingMask = .flexibleHeight
        self.imageScrollView.bounces = true

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.view.addSubViews([
            self.imageScrollView,
            self.closeButton
        ])

        self.imageScrollView.addSubview(self.contentView)

        self.contentView.addSubViews([
            self.itemImageView,
            self.displaySitenameLabel,
            self.dateTimeLabel
        ])

        self.setupLayouts()

        self.bindUI()
    }
    
    // MARK: - Function
    override func bindUI() {
        // 닫기 버튼 클릭 시 화면 닫기
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { _ in
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: self.disposeBag)

        // 이미지 바인딩
        self.viewModel.imageOb.bind(to: self.itemImageView.rx.image)
            .disposed(by: self.disposeBag)

        // 스크롤뷰 크기 바인딩
        self.viewModel.imageRectOb
            .bind(to: self.contentView.rx.frame)
            .disposed(by: self.disposeBag)

        // 스크롤뷰 컨텐츠 사이즈 바인딩
        self.viewModel.imageRectOb
            .map { $0.size }
            .bind(to: self.imageScrollView.rx.contentSize)
            .disposed(by: self.disposeBag)

        // 출처가 없을 경우 라벨 숨기기
        self.viewModel.docUrlOb
            .map { $0.isEmpty }
            .bind(to: self.displaySitenameLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        // 출처 바인딩
        self.viewModel.docUrlOb
            .bind(to: self.displaySitenameLabel.rx.text)
            .disposed(by: self.disposeBag)

        // 날짜가 없을 경우 라벨 숨기기
        self.viewModel.dateTimeOb
            .map { $0.isEmpty }
            .bind(to: self.dateTimeLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        // 날짜 바인딩
        self.viewModel.dateTimeOb
            .map { Utils.shared.convertIsoToKrFormat(dateStr: $0) }
            .bind(to: self.dateTimeLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    override func setupLayouts() {
        NSLayoutConstraint.activate([
            self.closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5),
            self.closeButton.widthAnchor.constraint(equalToConstant: 50),
            self.closeButton.heightAnchor.constraint(equalToConstant: 50),

            self.imageScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.imageScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.imageScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            // 넓이를 스크롤뷰와 동일하게 설정
            self.contentView.widthAnchor.constraint(equalTo: self.imageScrollView.widthAnchor),
            
            self.itemImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.itemImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.itemImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.itemImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            self.displaySitenameLabel.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: 10),
            self.displaySitenameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.displaySitenameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.displaySitenameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            self.dateTimeLabel.topAnchor.constraint(equalTo: self.displaySitenameLabel.bottomAnchor, constant: 10),
            self.dateTimeLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.dateTimeLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.dateTimeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
}
