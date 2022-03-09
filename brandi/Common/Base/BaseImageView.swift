//
//  BaseImageView.swift
//  Supermarket
//
//  Created by User on 2021/07/05.
//

import UIKit
import Kingfisher

class BaseImageView: UIImageView {
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(image: UIImage?) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.image = image
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.image = image
        self.highlightedImage = highlightedImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
}
