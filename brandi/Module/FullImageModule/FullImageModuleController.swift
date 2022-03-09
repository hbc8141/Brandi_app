//
//  FullImageController.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import UIKit
import RxSwift

class FullImageModuleController: BaseController {
    
    // MARK: - Properties
    private let closeButton:BaseButton = BaseButton(title: "X")
    
    private let itemImageView:BaseImageView = BaseImageView()
    
    private let displaySitenameLabel:BaseLabel = BaseLabel(textColor: .white, textAlignment: .center)
    
    private let dateTimeLabel:BaseLabel = BaseLabel(textColor: .white, textAlignment: .center)
    
    private let searchImage:BehaviorSubject<SearchImage?> = BehaviorSubject<SearchImage?>(value: nil)

    // MARK: - Life Cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(searchImage: SearchImage) {
        super.init(nibName: nil, bundle: nil)

        Observable.of(searchImage)
            .bind(to: self.searchImage)
            .disposed(by: self.disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.closeButton)
        self.view.addSubview(self.itemImageView)
        self.view.addSubview(self.displaySitenameLabel)
        self.view.addSubview(self.dateTimeLabel)
        
        self.setupLayouts()
        
        self.itemImageView.image = UIImage(named: "gull")
        self.dateTimeLabel.text = "안녕"
        self.displaySitenameLabel.text = "abc"
//        self.bindUI()
    }
    
    // MARK: - Function
    override func bindUI() {
        do {
            let abc = try self.searchImage.value()
            print(abc)
        } catch {
            
        }
        
        // 닫기 버튼 클릭 시 화면 닫기
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { _ in
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
        
        self.searchImage.subscribe(onNext: { image in
            print(image)
        }).disposed(by: self.disposeBag)
        
        let searchImageOb:Observable<SearchImage> = self.searchImage.flatMap { (searchImage:SearchImage?) -> Observable<SearchImage> in
            guard let searchImage:SearchImage = searchImage else {
                return .empty()
            }
            
            return .just(searchImage)
        }
        
//        // 전체 이미지 대입
//        searchImageOb.flatMap { (searchImage:SearchImage) -> Observable<UIImage?> in
//            guard let url:URL = URL(string: searchImage.image_url) else { return .empty() }
//
//            do {
//                let data:Data = try Data(contentsOf: url)
//
//                let fullImage:UIImage? = UIImage(data: data)
//
//                return .just(fullImage)
//            } catch {
//                print(error.localizedDescription)
//                return .just(UIImage())
//            }
//        }.bind(to: self.itemImageView.rx.image)
//        .disposed(by: self.disposeBag)
//
//        // 출처 대입
//        searchImageOb.map { $0.doc_url }
//            .bind(to: self.displaySitenameLabel.rx.text)
//            .disposed(by: self.disposeBag)
//
//        // 날짜 대입
//        searchImageOb.map { Utils().convertIsoToKrFormat(dateStr: $0.datetime) }
//            .bind(to: self.dateTimeLabel.rx.text)
//            .disposed(by: self.disposeBag)
    }
    
    override func setupLayouts() {
        let width:CGFloat = UIScreen.main.bounds.width
        
        // 4:3 비율로 하기 위해 크기 조정
        let height:CGFloat = width / 3 * 4

        NSLayoutConstraint.activate([
            self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5),
            self.closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5),
            self.closeButton.widthAnchor.constraint(equalToConstant: 50),
            self.closeButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.itemImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.itemImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.itemImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.itemImageView.heightAnchor.constraint(equalToConstant: height),
            
            self.displaySitenameLabel.topAnchor.constraint(equalTo: self.itemImageView.bottomAnchor, constant: 10),
            self.displaySitenameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.displaySitenameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.displaySitenameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            self.dateTimeLabel.topAnchor.constraint(equalTo: self.displaySitenameLabel.bottomAnchor, constant: 10),
            self.dateTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.dateTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.dateTimeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
}
