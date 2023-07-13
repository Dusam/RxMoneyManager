//
//  SettingViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/21.
//

import UIKit
import SamUtils
import RxCocoa
import SnapKit
import RxSwift

class SettingViewController: BaseViewController {
    
    private var detailVM: DetailViewModel!
    private var colorPickerButton: UIButton!
    
    init(detailVM: DetailViewModel) {
        self.detailVM = detailVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpView() {
        setBackButton(title: R.string.localizable.setting())
        setUpThemeColorView()
    }
    
    override func bindUI() {
        bindColorPickerButton()
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.colorPickerButton.cornerRadius = self.colorPickerButton.width / 2
        }
    }
}

// MARK: SetUpView
extension SettingViewController {
    private func setUpThemeColorView() {
        let themeColorTitle = UILabel()
        themeColorTitle.font = .systemFont(ofSize: 20)
        themeColorTitle.text = R.string.localizable.theme_color()
        view.addSubview(themeColorTitle)
                
        themeColorTitle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.left.equalTo(safeAreaLayoutGuide).offset(20)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.8)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
        }
        
        colorPickerButton = UIButton()
        colorPickerButton.backgroundColor = UserInfo.share.themeColor
        view.addSubview(colorPickerButton)
        
        colorPickerButton.snp.makeConstraints { make in
            make.right.equalTo(safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(colorPickerButton.snp.height)
            make.width.equalTo(safeAreaLayoutGuide).multipliedBy(0.08)
            make.centerY.equalTo(themeColorTitle)
        }
    }
}


//MARK: BindUI
extension SettingViewController {
    private func bindColorPickerButton() {
        colorPickerButton.rx.tap
            .subscribe(onNext: {
                let colorPicker = UIColorPickerViewController()
                colorPicker.delegate = self
                colorPicker.selectedColor = UserInfo.share.themeColor
                self.present(colorPicker, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        colorPickerButton.backgroundColor = color
        detailVM.setThemeColor(color)
    }
}
