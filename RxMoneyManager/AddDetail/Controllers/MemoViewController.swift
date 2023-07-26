//
//  MemoViewController.swift
//  RxMoneyManager
//
//  Created by 杜千煜 on 2023/6/19.
//

import UIKit
import SamUtils
import SnapKit
import RxSwift
import RxCocoa

class MemoViewController: BaseViewController {
    
    @Inject private var addDetailVM: AddDetailViewModelType
//    private var addDetailVM: AddDetailViewModel!
    private var memoTextView: UITextView!
    private var memoTableView: UITableView!
    
//    init(addDetailVM: AddDetailViewModel!) {
//        self.addDetailVM = addDetailVM
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func setUpView() {
        setBackButton(title: R.string.localizable.memo())
        setUpTextView()
        setUpTableView()
        
        addDetailVM.getMemos()
    }
    
    override func bindUI() {
        bindTextView()
        bindTableView()
    }
    
    deinit {
#if DEBUG
        print("MemoViewController deinit")
#endif
    }
    
}

// MARK: SetUpView
extension MemoViewController {
    private func setUpTextView() {
        memoTextView = UITextView()
        memoTextView.font = .systemFont(ofSize: 20)
        memoTextView.borderColor = .lightGray
        memoTextView.borderWidth = 1
        memoTextView.cornerRadius = 15
        memoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(memoTextView)
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.left.equalTo(safeAreaLayoutGuide).offset(10)
            make.right.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.4)
        }
    }
    
    private func setUpTableView() {
        memoTableView = UITableView()
        memoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MemoCell")
        memoTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(memoTableView)
        
        memoTableView.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(5)
            make.left.equalTo(safeAreaLayoutGuide).offset(10)
            make.right.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }
}


// MARK: BindUI
extension MemoViewController {
    private func bindTextView() {
        addDetailVM.output.memo
            .drive(memoTextView.rx.text)
            .disposed(by: disposeBag)
        
        memoTextView.rx.text.orEmpty
            .changed
            .subscribe(onNext: { [weak self] memo in
                self?.addDetailVM.setMemo(memo)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        addDetailVM.output.memoModels
            .drive(memoTableView.rx.items(cellIdentifier: "MemoCell", cellType: UITableViewCell.self)) { row, data, cell in
                var config = cell.defaultContentConfiguration()
                config.text = data.memo.replacingOccurrences(of: "\n", with: " ")
                config.textProperties.font = .systemFont(ofSize: 20)
                cell.contentConfiguration = config
            }
            .disposed(by: disposeBag)
        
        memoTableView.rx.modelSelected(MemoModel.self)
            .subscribe(onNext: { [weak self] data in
                self?.addDetailVM.setMemo(data.memo)
            })
            .disposed(by: disposeBag)
    }
}
