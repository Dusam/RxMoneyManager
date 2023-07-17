//
//  AddDetailViewModelTests.swift
//  RxMoneyManagerTests
//
//  Created by 杜千煜 on 2023/7/13.
//

import Quick
import Nimble
import RxTest

@testable import RxMoneyManager
@testable import RxSwift
@testable import RxCocoa

class AddDetailViewModelTests: QuickSpec {
    override class func spec() {
        describe("AddDetailViewModel") {
            var viewModel: AddDetailViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            var testDate: String = ""
            var spendMemo: String = ""
            
            beforeEach {
                viewModel = AddDetailViewModel()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                UserInfo.share.selectedDate = Date().adding(.day, value: 1)
                testDate = UserInfo.share.selectedDate.string(withFormat: "yyyy-MM-dd")
                spendMemo = testDate + UUID().uuidString
            }
            
            afterEach {
                viewModel = nil
                scheduler = nil
                disposeBag = nil
                UserInfo.share.selectedDate = Date()
                testDate = ""
                spendMemo = ""
            }
            
            context("when initialized") {
                it("should have the correct initial values") {
                    let amountObserver = scheduler.createObserver(String.self)
                    let transferFeeObserver = scheduler.createObserver(String.self)
                    let isShowCalcutorObserver = scheduler.createObserver(Bool.self)
                    let selectedSegmentObserver = scheduler.createObserver(Int.self)
                    let addDetailCellModelsObserver = scheduler.createObserver([String].self)
                    let detailGroupModelsObserver = scheduler.createObserver([DetailGroupModel].self)
                    let detailTypeModelsObserver = scheduler.createObserver([DetailTypeModel].self)
                    let typeNameObserver = scheduler.createObserver(String.self)
                    let detailGroupIdObserver = scheduler.createObserver(String.self)
                    let detailTypeIdObserver = scheduler.createObserver(String.self)
                    let accountNameObserver = scheduler.createObserver(String.self)
                    let accountModelsObserver = scheduler.createObserver([AccountModel].self)
                    let toAccountNameObserver = scheduler.createObserver(String.self)
                    let memoObserver = scheduler.createObserver(String.self)
                    let memoModelsObserver = scheduler.createObserver([MemoModel].self)
                    
                    viewModel.amount
                        .drive(amountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.transferFee
                        .drive(transferFeeObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.isShowCalcutor
                        .drive(isShowCalcutorObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.billingSegment
                        .drive(selectedSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.addDetailCellModels
                        .drive(addDetailCellModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.detailGroupModels
                        .drive(detailGroupModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.detailTypeModels
                        .drive(detailTypeModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.typeName
                        .drive(typeNameObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.detailGroupId
                        .drive(detailGroupIdObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.detailTypeId
                        .drive(detailTypeIdObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.accountName
                        .drive(accountNameObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.accountModels
                        .drive(accountModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.toAccountName
                        .drive(toAccountNameObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.memo
                        .drive(memoObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.memoModels
                        .drive(memoModelsObserver)
                        .disposed(by: disposeBag)
                  
                    scheduler.start()
                    
//                    debugPrint(self, "amountObserver: \(amountObserver.events)")
                    expect(amountObserver.events.first?.value.element).to(equal("0"))
                    expect(transferFeeObserver.events.first?.value.element).to(equal("0"))
                    expect(isShowCalcutorObserver.events.first?.value.element).to(beFalse())
                    expect(selectedSegmentObserver.events.first?.value.element).to(equal(0))
                    expect(addDetailCellModelsObserver.events.first?.value.element?.count).to(equal(3))
                    expect(detailGroupModelsObserver.events.first?.value.element?.isEmpty).to(beFalse())
                    expect(detailTypeModelsObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(typeNameObserver.events.first?.value.element).toNot(equal(""))
                    expect(detailGroupIdObserver.events.first?.value.element).to(equal(UserInfo.share.expensesGroupId))
                    expect(detailTypeIdObserver.events.first?.value.element).to(equal(UserInfo.share.expensesTypeId))
                    expect(accountNameObserver.events.first?.value.element).toNot(equal(""))
                    expect(accountModelsObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(toAccountNameObserver.events.first?.value.element).toNot(equal(""))
                    expect(memoObserver.events.first?.value.element).to(equal(""))
                    expect(memoModelsObserver.events.first?.value.element?.isEmpty).to(beTrue())
                }
            }
            
            context("save detail") {
                it("can not save when amount <= 0 or accountId is error") {
                    let amountObserver = scheduler.createObserver(String.self)
                    
                    viewModel.amount
                        .drive(amountObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    viewModel.setAmount("-15")
                    viewModel.setAccountId("1")
                    viewModel.setBillingType(.spend)
                    viewModel.saveDetail()
                    
                    var count = RealmManager.share.readDetail("2023-07-14").count
                    expect(count).to(equal(0))
                    
                    viewModel.setAmount("0")
                    viewModel.setAccountId("64a65e95d3f890f8458eb0da")
                    viewModel.setToAccountId("64a503c0828b916fa8c4afa9")
                    viewModel.setBillingType(.transfer)
                    viewModel.saveDetail()
                    
                    count = RealmManager.share.readDetail("2023-07-14").count
                    expect(count).to(equal(0))
                }
                
                it("can save when amount > 0 and accountId is not error and memo is new and type is spend") {
                    let amountObserver = scheduler.createObserver(String.self)
                    
                    viewModel.amount
                        .drive(amountObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                                        
                    // 新增支出
                    viewModel.setAmount("50")
                    viewModel.setAccountId("649d2e2f178caebfe8715c5e")
                    viewModel.setBillingType(.spend)
                    viewModel.setMemo(spendMemo)
                    viewModel.saveDetail()
                    var details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(1))
                    expect(amountObserver.events.last?.value.element).to(equal("50"))
                    // 刪除剛剛新增的
                    details = RealmManager.share.readDetail(testDate)
                    viewModel.setEditData(details.first!)
                    viewModel.delDetail()
                    details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(0))
                }
                
                it("can save when amount > 0 and accountId is not error and memo is repeat and type is spend") {
                    let amountObserver = scheduler.createObserver(String.self)
                    
                    viewModel.amount
                        .drive(amountObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                                        
                    // 新增支出2
                    viewModel.setAmount("1600")
                    viewModel.setAccountId("649d2e2f178caebfe8715c5e")
                    viewModel.setBillingType(.spend)
                    viewModel.setMemo(spendMemo)
                    viewModel.saveDetail()
                    var details = RealmManager.share.readDetail(testDate)
                    details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(1))
                    expect(amountObserver.events.last?.value.element).to(equal("1600"))
                    // 刪除剛剛新增的
                    details = RealmManager.share.readDetail(testDate)
                    viewModel.setEditData(details.first!)
                    viewModel.delDetail()
                    details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(0))
                }
                
                it("can save when amount > 0 and accountId is not error and type is income") {
                    let amountObserver = scheduler.createObserver(String.self)
                    
                    viewModel.amount
                        .drive(amountObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                                        
                    // 新增收入
                    viewModel.setAmount("14230")
                    viewModel.setAccountId("64a65e95d3f890f8458eb0da")
                    viewModel.setBillingType(.income)
                    viewModel.setMemo("電話補助費")
                    viewModel.saveDetail()
                    var details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(1))
                    expect(amountObserver.events.last?.value.element).to(equal("14230"))
                    // 刪除剛剛新增的
                    details = RealmManager.share.readDetail(testDate)
                    viewModel.setEditData(details.first!)
                    viewModel.delDetail()
                    details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(0))
                }
                
                it("can save when amount > 0 and accountId is not error and type is transfer") {
                    let amountObserver = scheduler.createObserver(String.self)
                    let transFeeObserver = scheduler.createObserver(String.self)
                    
                    viewModel.amount
                        .drive(amountObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.transferFee
                        .drive(transFeeObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                 
                    // 新增轉帳
                    viewModel.setAmount("1000")
                    viewModel.setAccountId("64a65e95d3f890f8458eb0da")
                    viewModel.setToAccountId("64a503c0828b916fa8c4afa9")
                    viewModel.setBillingType(.transfer)
                    viewModel.setMemo("薩爾達傳說")
                    viewModel.setTransferFee("15")
                    viewModel.saveDetail()
                    var details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(2))
                    expect(amountObserver.events.last?.value.element).to(equal("1000"))
                    expect(transFeeObserver.events.last?.value.element).to(equal("15"))
                    // 刪除剛剛新增的
                    details = RealmManager.share.readDetail(testDate)
                    viewModel.setEditData(details.first!)
                    viewModel.delDetail()
                    viewModel.setEditData(details.last!)
                    viewModel.delDetail()
                    details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(0))
                }
                
                it("save changes to existing detail") {
                    let amountObserver = scheduler.createObserver(String.self)
                    
                    viewModel.amount
                        .drive(amountObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                                        
                    // 新增支出
                    viewModel.setAmount("50")
                    viewModel.setAccountId("649d2e2f178caebfe8715c5e")
                    viewModel.setBillingType(.spend)
                    viewModel.setMemo(spendMemo)
                    viewModel.saveDetail()
                    var details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(1))
                    expect(amountObserver.events.last?.value.element).to(equal("50"))
                    
                    viewModel.setEditData(details.first!)
                    viewModel.setBillingType(.income)
                    viewModel.saveDetail()
                    details = RealmManager.share.readDetail(testDate)
                    expect(details.first?.billingType).to(equal(BillingType.income.rawValue))
                    
                    // 刪除剛剛新增的
                    details = RealmManager.share.readDetail(testDate)
                    viewModel.setEditData(details.first!)
                    viewModel.delDetail()
                    details = RealmManager.share.readDetail(testDate)
                    expect(details.count).to(equal(0))
                }
            }
            
            context("calcutor") {
                it("change calcutor view status") {
                    let isShowCalcutorObserver = scheduler.createObserver(Bool.self)
                    
                    viewModel.isShowCalcutor
                        .drive(isShowCalcutorObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    // 確認初始值是 false
                    expect(isShowCalcutorObserver.events.first?.value.element).to(beFalse())
                    
                    viewModel.setShowCalcutor(true)
                    expect(isShowCalcutorObserver.events.last?.value.element).to(beTrue())
                }
                
            }
            
            context("detail group/type") {
                it("add/delete group") {
                    let detailGroupModelsObserver = scheduler.createObserver([DetailGroupModel].self)
                    let detailTypeModelsObserver = scheduler.createObserver([DetailTypeModel].self)
                    
                    viewModel.detailGroupModels
                        .drive(detailGroupModelsObserver)
                        .disposed(by: disposeBag)
                    
                    viewModel.detailTypeModels
                        .drive(detailTypeModelsObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    // 新增
                    let existingGroups = RealmManager.share.getDetailGroup(billType: .spend)
                    viewModel.addGroup("測試群組")
                    let groups = RealmManager.share.getDetailGroup(billType: .spend)
                    let selectedGroupId = viewModel.getGroupId()
                    expect(existingGroups.count).to(beLessThan(groups.count))
                    
                    
                    let existingTypes = RealmManager.share.getDetailType(selectedGroupId)
                    viewModel.addType("測試類別")
                    let types = RealmManager.share.getDetailType(selectedGroupId)
                    viewModel.setSelectType(types.last!.id.stringValue)
                    
                    let selectedTypeId = viewModel.getTypeId()
                    expect(existingTypes.count).to(beLessThan(types.count))
                    expect(selectedGroupId).to(equal(groups.last?.id.stringValue)) // 新增 Type 後才會是正確的 groupId
                    expect(selectedTypeId).to(equal(types.last?.id.stringValue))
                    
                    // 刪除
                    viewModel.deleteGroup(groups.last!)
                    let afterDeleteGroups = RealmManager.share.getDetailGroup(billType: .spend)
                    expect(viewModel.getGroupId()).toNot(equal(afterDeleteGroups.last?.id.stringValue))
                }
                
                it("add/delete type") {
                    let detailTypeModelsObserver = scheduler.createObserver([DetailTypeModel].self)
                    
                    viewModel.detailTypeModels
                        .drive(detailTypeModelsObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    // 新增
                    let selectedGroupId = viewModel.getGroupId()
                    let existingTypes = RealmManager.share.getDetailType(selectedGroupId)
                    viewModel.addType("測試類別")
                    let types = RealmManager.share.getDetailType(selectedGroupId)
                    viewModel.setSelectType(types.last!.id.stringValue)
                    
                    let selectedTypeId = viewModel.getTypeId()
                    expect(existingTypes.count).to(beLessThan(types.count))
                    expect(selectedTypeId).to(equal(types.last?.id.stringValue))
                    
                    // 刪除
                    viewModel.deleteType(types.last!)
                    let afterDeleteTypes = RealmManager.share.getDetailType(selectedGroupId)
                    expect(viewModel.getTypeId()).toNot(equal(afterDeleteTypes.last?.id.stringValue))
                }
            }
            
            context("billing type segment") {
                it("should have correct value after setting segment index") {
                    let billingSegmentObserver = scheduler.createObserver(Int.self)
                    
                    viewModel.billingSegment
                        .drive(billingSegmentObserver)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(billingSegmentObserver.events.first?.value.element).to(equal(0))
                    
                    viewModel.setBillingSegmentIndex(2)
                    expect(billingSegmentObserver.events.last?.value.element).to(equal(2))
                    expect(viewModel.getSegmentIndex()).to(equal(2))
                }
            }
            
            context("other get method") {
                it("should have correct value after set") {
                    let accountsObserver = scheduler.createObserver([AccountModel].self)
                    var accountId = viewModel.getAccountId()
                    var toAccountId = viewModel.getToAccountId()
                    
                    viewModel.accountModels
                        .drive(accountsObserver)
                        .disposed(by: disposeBag)
        
                    scheduler.start()
                    
                    expect(accountsObserver.events.first?.value.element?.isEmpty).to(beTrue())
                    expect(accountId).to(equal(UserInfo.share.accountId))
                    expect(toAccountId).to(equal(UserInfo.share.transferToAccountId))
                    
                    viewModel.getAccounts()
                    viewModel.setAccountId("23456")
                    viewModel.setToAccountId("9987655")
                    
                    accountId = viewModel.getAccountId()
                    toAccountId = viewModel.getToAccountId()
                    
                    expect(accountsObserver.events.last?.value.element?.isEmpty).to(beFalse())
                    expect(accountId).to(equal("23456"))
                    expect(toAccountId).to(equal("9987655"))
                }
            }
        }
    }
}
