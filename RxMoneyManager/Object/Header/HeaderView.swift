//
//  HeaderView.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/5/26.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxGesture

class HeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let headerVM = HeaderViewModel()
    private var headerType: HeaderType = .detail
    
    required init(headerType: HeaderType) {
        super.init(frame: CGRect.zero)
        self.headerType = headerType
        
        self.headerVM.setHeaderType(headerType)
        setUpHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if DEBUG
        print("HeaderView deinit")
        #endif
    }
    
    private func setUpHeaderView() {
        
        // 設定橫向 StackView
        func setUpStackView() {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            
            addSubview(stackView)
          
            stackView.snp.makeConstraints { make in
                make.top.bottom.left.right.equalToSuperview()
            }
            
            let perviousButton = setUpPerviousButton()
            let centerView = setUpCenterView()
            let nextButton = setUpNextButton()
            
            stackView.addArrangedSubviews([perviousButton, centerView, nextButton])
            
            perviousButton.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.2)
            }
            
            nextButton.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.2)
            }
        }
        
        // 設定中間的 StackView(日期及共用標籤)
        func setUpCenterView() -> UIStackView {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            
            let dateLabel = setUpDateButton()
            let subTitleLabel = setUpSubTitleLabel()
            stackView.addArrangedSubviews([dateLabel, subTitleLabel])
          
            return stackView
        }
        
        // 設定日期按鈕
        func setUpDateButton() -> UIButton {
            let dateButton = UIButton()
            dateButton.titleLabel?.textAlignment = .center
            dateButton.titleLabel?.font = .systemFont(ofSize: 18)
            dateButton.setTitleColor(.black, for: .normal)
            dateButton.setTitleColor(.white, for: .highlighted)
            
            dateButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.headerVM.toCurrentDate()
            })
            .disposed(by: disposeBag)
            
            headerVM.currentDate
                .asDriver()
                .drive(dateButton.rx.title())
                .disposed(by: disposeBag)
            
            return dateButton
        }
        
        // 設定共用標籤
        func setUpSubTitleLabel() -> UILabel {
            let subTitleLabel = UILabel()
            subTitleLabel.textAlignment = .center
            subTitleLabel.font = .systemFont(ofSize: 18)
            
            if headerType == .detail {
                DetailViewModel.shared.totalAmount
                    .map{ "$TW \($0)" }
                    .asDriver(onErrorJustReturn: "")
                    .drive(subTitleLabel.rx.text)
                    .disposed(by: disposeBag)
            } else {
                subTitleLabel.isHidden = true
            }
            
            return subTitleLabel
        }
        
        // 設定上一天按鈕
        func setUpPerviousButton() -> UIButton {
            let perviousButton = UIButton()
            perviousButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            perviousButton.tintColor = .white
            perviousButton.imageView?.contentMode = .scaleAspectFill
            
            perviousButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.headerVM.toPerviousDate()
            })
            .disposed(by: disposeBag)
            
            return perviousButton
        }
        
        // 設定下一天按鈕
        func setUpNextButton() -> UIButton {
            let nextButton = UIButton()
            nextButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
            nextButton.tintColor = .white
            nextButton.imageView?.contentMode = .scaleAspectFill
            
            nextButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.headerVM.toNextDate()
            })
            .disposed(by: disposeBag)
            
            return nextButton
        }

        backgroundColor = .lightGray
        setUpStackView()
    }

}
