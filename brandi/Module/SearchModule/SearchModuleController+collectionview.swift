//
//  SearchModuleController+collectionview.swift
//  brandi
//
//  Created by User on 2022/03/08.
//

import UIKit

extension SearchModuleController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 단발기의 넓이
        let width:CGFloat = UIScreen.main.bounds.width
        
        // 3 * n 으로 구현하기 위해 단말기 넓이에서 3을 나눈 값
        let squareSize:CGFloat = width / 3
        
        return CGSize(width: squareSize, height: squareSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
