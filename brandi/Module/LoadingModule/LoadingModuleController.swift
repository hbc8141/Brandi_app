//
//  LoadingModuleController.swift
//  brandi
//
//  Created by User on 2022/03/09.
//

import UIKit
import RxSwift
import RxCocoa

class LoadingModuleController: BaseController {
    
    // MARK: - Properties
    // 검색 바
    private let searchBar:BaseSearchBar = BaseSearchBar()

    // ViewModel
    private let viewModel:SearchModuleViewModel = SearchModuleViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubViews([
            self.searchBar
        ])

        self.setupLayouts()
        self.bindUI()
    }

    // MARK: - Function
    override func bindUI() {
        
    }
    
    override func setupLayouts() {
        NSLayoutConstraint.activate([
            self.searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchBar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.searchBar.widthAnchor.constraint(equalToConstant: 250),
            self.searchBar.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

