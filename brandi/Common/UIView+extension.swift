//
//  UIView+extension.swift
//  brandi
//
//  Created by User on 2022/03/09.
//

import UIKit

extension UIView {
    
    // 여러 뷰를 한번에 추가
    func addSubViews(_ views: [UIView]) -> Void {
        for view in views {
            self.addSubview(view)
        }
    }
}
