//
//  BaseCell.swift
//  Karrot
//
//  Created by User on 2021/07/20.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var disposeBag:DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.selectedBackgroundView = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    func setupLayouts() -> Void {}
    
    func bindUI() -> Void {}
}
