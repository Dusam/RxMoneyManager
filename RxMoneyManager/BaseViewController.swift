//
//  BaseViewViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/29.
//

import UIKit
import SamUtils
import RxSwift
import RxCocoa
import SnapKit
import RxGesture
import RxDataSources

class BaseViewController: UIViewController {

    var safeAreaLayoutGuide: UILayoutGuide!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        
        self.initView()
    }
    
    private func initView() {
        setUpView()
        bindUI()
    }
    
    func setUpView() {
        
    }
    
    func bindUI() {
        
    }

}
