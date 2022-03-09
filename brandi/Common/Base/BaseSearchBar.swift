//
//  BaseSearchBar.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import UIKit

class BaseSearchBar: UISearchBar {
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
