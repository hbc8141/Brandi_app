//
//  UIScrollView+extension.swift
//  brandi
//
//  Created by User on 2022/03/09.
//

import UIKit

extension UIScrollView {
    
    // 스크롤 뷰가 바닥 아래로 닿는 부분 감지
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
