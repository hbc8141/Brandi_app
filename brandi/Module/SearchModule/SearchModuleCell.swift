//
//  SearchModuleCell.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import UIKit
import RxSwift
import Kingfisher

class SearchModuleCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    var document:SearchImage? {
        didSet {
            guard let document:SearchImage = document else { return }
            
            Observable.of(document.thumbnail_url).flatMap { (url:String) -> Observable<UIImage?> in
                guard let url:URL = URL(string: url) else {
                    return .empty()
                }

                do {
                    let data:Data = try Data(contentsOf: url)
                    
                    let image:UIImage? = UIImage(data: data)
                    
                    return .just(image)
                } catch {
                    return .just(nil)
                }
            }.bind(to: self.itemImageView.rx.image)
            .disposed(by: self.disposeBag)
        }
    }
    
    private let itemImageView:BaseImageView = BaseImageView()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.itemImageView)
        
        self.setupLayouts()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    override func setupLayouts() {
        NSLayoutConstraint.activate([
            self.itemImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.itemImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.itemImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.itemImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
