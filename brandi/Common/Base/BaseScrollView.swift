//
//  BaseScrollView.swift
//  Flapic
//
//  Created by User on 2021/09/30.
//

import UIKit

class BaseScrollView: UIScrollView {

    // MARK: - Properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = true
    }
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
