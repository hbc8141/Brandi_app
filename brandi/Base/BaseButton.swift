//
//  BaseButton.swift
//  Supermarket
//
//  Created by User on 2021/07/02.
//

import UIKit

class BaseButton: UIButton {

    // MARK: - Initialization
    // 일반 버튼
    init(title: String? = nil, backgroundColor: UIColor? = UIColor.black) {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 5
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
