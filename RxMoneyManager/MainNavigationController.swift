//
//  MainNavigationController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/25.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationController()
    }
    
    private func setUpNavigationController() {
        // 顯示導航列
        navigationBar.isHidden = false
        
        // 設定導航列外觀
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            navigationBar.barTintColor = .red // 導航列的背景色
            navigationBar.tintColor = .white // 導航列的按鈕顏色
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // 導航列標題的文字屬性
        }
    }
}
