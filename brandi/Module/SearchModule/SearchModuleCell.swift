//
//  SearchModuleCell.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxKingfisher
import Kingfisher

class SearchModuleCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    var document:SearchImage? {
        didSet {
            guard let document:SearchImage = document else { return }
            
            Observable.of(document.thumbnail_url)
                .map { URL(string: $0) }
                .bind(to: self.itemImageView.kf.rx.image(placeholder: UIImage(named: "empty"), options: nil))
                .disposed(by: self.disposeBag)
        }
    }
    
    private let itemImageView:UIImageView = {
        let imageView:UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubViews([
            self.itemImageView
        ])
        
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
