//
//  BaseViewViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/29.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewViewController: UIViewController {

    var safeAreaLayoutGuide: UILayoutGuide!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
    }

}
