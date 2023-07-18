//
//  CalculatorViewModelTests.swift
//  RxMoneyManagerTests
//
//  Created by 杜千煜 on 2023/7/18.
//

import Quick
import Nimble
import RxTest

@testable import RxMoneyManager
@testable import RxSwift
@testable import RxCocoa

class CalculatorViewModelTests: QuickSpec {
    override class func spec() {
        describe("DetailChartViewModel") {
            var viewModel: CalculatorViewModel!
            
            beforeEach {
                viewModel = CalculatorViewModel()
            }
            
            afterEach {
                viewModel = nil
            }
            
            context("when initialized") {
                it("should have the correct initial values") {
                    expect(viewModel.amountString).to(equal("0"))
                    expect(viewModel.amountValue).to(equal(0.0))
                    expect(viewModel.transferString).to(equal("0"))
                    expect(viewModel.transferValue).to(equal(0.0))
                    expect(viewModel.currentOperation).to(equal(Operation.none))
                    expect(viewModel.isEditAmount).to(beTrue())
                }
                
                it("setting viewModel with add detail") {
                    viewModel.setViewModel(AddDetailViewModel())
                    
                    expect(viewModel.addDetailVM).notTo(beNil())
                }
                
                it("setting viewModel with add account") {
                    viewModel.setViewModel(AddAccountViewModel())
                    
                    expect(viewModel.addAccountVM).notTo(beNil())
                }
            }
            
            context("calcutor amount") {
                it("add") {
                    viewModel.setEditType(isEditAmount: true)
                    
                    viewModel.buttonTap(.one)
                    expect(viewModel.amountString).to(equal("1"))
                    viewModel.buttonTap(.two)
                    expect(viewModel.amountString).to(equal("12"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.amountString).to(equal("123"))
                    viewModel.buttonTap(.add)
                    expect(viewModel.amountString).to(equal("123+"))
                    viewModel.buttonTap(.four)
                    expect(viewModel.amountString).to(equal("123+4"))
                    viewModel.buttonTap(.five)
                    expect(viewModel.amountString).to(equal("123+45"))
                    viewModel.buttonTap(.six)
                    expect(viewModel.amountString).to(equal("123+456"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("579"))
                    expect(viewModel.amountValue).to(equal(0.0))
                }
                
                it("subtract") {
                    viewModel.setEditType(isEditAmount: true)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.amountString).to(equal("9"))
                    viewModel.buttonTap(.eight)
                    expect(viewModel.amountString).to(equal("98"))
                    viewModel.buttonTap(.seven)
                    expect(viewModel.amountString).to(equal("987"))
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.amountString).to(equal("987-"))
                    viewModel.buttonTap(.six)
                    expect(viewModel.amountString).to(equal("987-6"))
                    viewModel.buttonTap(.five)
                    expect(viewModel.amountString).to(equal("987-65"))
                    viewModel.buttonTap(.four)
                    expect(viewModel.amountString).to(equal("987-654"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("333"))
                    expect(viewModel.amountValue).to(equal(0.0))
                }
                
                it("multiply") {
                    viewModel.buttonTap(.nine)
                    expect(viewModel.amountString).to(equal("9"))
                    viewModel.buttonTap(.multiply)
                    expect(viewModel.amountString).to(equal("9x"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.amountString).to(equal("9x3"))
                    viewModel.buttonTap(.four)
                    expect(viewModel.amountString).to(equal("9x34"))
                    viewModel.buttonTap(.del)
                    expect(viewModel.amountString).to(equal("9x3"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("27"))
                    expect(viewModel.amountValue).to(equal(0.0))
                }
                
                it("divide") {
                    viewModel.buttonTap(.nine)
                    expect(viewModel.amountString).to(equal("9"))
                    viewModel.buttonTap(.divide)
                    expect(viewModel.amountString).to(equal("9÷"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.amountString).to(equal("9÷3"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("3"))
                    expect(viewModel.amountValue).to(equal(0))
                    viewModel.buttonTap(.clear)
                    expect(viewModel.amountString).to(equal("0"))
                }
            }
            
            context("calcutor transfer fee") {
                it("add") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.one)
                    expect(viewModel.transferString).to(equal("1"))
                    viewModel.buttonTap(.two)
                    expect(viewModel.transferString).to(equal("12"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.transferString).to(equal("123"))
                    viewModel.buttonTap(.add)
                    expect(viewModel.transferString).to(equal("123+"))
                    viewModel.buttonTap(.four)
                    expect(viewModel.transferString).to(equal("123+4"))
                    viewModel.buttonTap(.five)
                    expect(viewModel.transferString).to(equal("123+45"))
                    viewModel.buttonTap(.six)
                    expect(viewModel.transferString).to(equal("123+456"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("579"))
                    expect(viewModel.transferValue).to(equal(0.0))
                }
                
                it("subtract") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.transferString).to(equal("9"))
                    viewModel.buttonTap(.eight)
                    expect(viewModel.transferString).to(equal("98"))
                    viewModel.buttonTap(.seven)
                    expect(viewModel.transferString).to(equal("987"))
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.transferString).to(equal("987-"))
                    viewModel.buttonTap(.six)
                    expect(viewModel.transferString).to(equal("987-6"))
                    viewModel.buttonTap(.five)
                    expect(viewModel.transferString).to(equal("987-65"))
                    viewModel.buttonTap(.four)
                    expect(viewModel.transferString).to(equal("987-654"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("333"))
                    expect(viewModel.transferValue).to(equal(0.0))
                }
                
                it("multiply") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.transferString).to(equal("9"))
                    viewModel.buttonTap(.multiply)
                    expect(viewModel.transferString).to(equal("9x"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.transferString).to(equal("9x3"))
                    viewModel.buttonTap(.four)
                    expect(viewModel.transferString).to(equal("9x34"))
                    viewModel.buttonTap(.del)
                    expect(viewModel.transferString).to(equal("9x3"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("27"))
                    expect(viewModel.transferValue).to(equal(0.0))
                }
                
                it("divide") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.transferString).to(equal("9"))
                    viewModel.buttonTap(.divide)
                    expect(viewModel.transferString).to(equal("9÷"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.transferString).to(equal("9÷3"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("3"))
                    expect(viewModel.transferValue).to(equal(0))
                    viewModel.buttonTap(.clear)
                    expect(viewModel.transferString).to(equal("0"))
                }
            }
            
            context("calculator exception amount") {
                it("add") {
                    viewModel.setEditType(isEditAmount: true)
                    
                    viewModel.buttonTap(.one)
                    expect(viewModel.amountString).to(equal("1"))
                    viewModel.buttonTap(.add)
                    expect(viewModel.amountString).to(equal("1+"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("1"))
                    expect(viewModel.amountValue).to(equal(0.0))
                }
                
                it("subtract") {
                    viewModel.setEditType(isEditAmount: true)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.amountString).to(equal("9"))
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.amountString).to(equal("9-"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("9"))
                    expect(viewModel.amountValue).to(equal(0.0))
                    
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.amountString).to(equal("9-"))
                    viewModel.buttonTap(.one)
                    expect(viewModel.amountString).to(equal("9-1"))
                    viewModel.buttonTap(.two)
                    expect(viewModel.amountString).to(equal("9-12"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("-3"))
                    expect(viewModel.amountValue).to(equal(0.0))
                    
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.amountString).to(equal("-3-"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.amountString).to(equal("-3-3"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("-6"))
                    expect(viewModel.amountValue).to(equal(0.0))
                }
                
                it("multiply") {
                    viewModel.buttonTap(.nine)
                    expect(viewModel.amountString).to(equal("9"))
                    viewModel.buttonTap(.multiply)
                    expect(viewModel.amountString).to(equal("9x"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("9"))
                    expect(viewModel.amountValue).to(equal(0.0))
                }
                
                it("divide") {
                    viewModel.buttonTap(.nine)
                    expect(viewModel.amountString).to(equal("9"))
                    viewModel.buttonTap(.divide)
                    expect(viewModel.amountString).to(equal("9÷"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.amountString).to(equal("9"))
                    expect(viewModel.amountValue).to(equal(0))
                    viewModel.buttonTap(.clear)
                    expect(viewModel.amountString).to(equal("0"))
                }
            }
            
            context("calculator exception transfer fee") {
                it("add") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.one)
                    expect(viewModel.transferString).to(equal("1"))
                    viewModel.buttonTap(.add)
                    expect(viewModel.transferString).to(equal("1+"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("1"))
                    expect(viewModel.transferValue).to(equal(0.0))
                }
                
                it("subtract") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.transferString).to(equal("9"))
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.transferString).to(equal("9-"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("9"))
                    expect(viewModel.transferValue).to(equal(0.0))
                    
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.transferString).to(equal("9-"))
                    viewModel.buttonTap(.one)
                    expect(viewModel.transferString).to(equal("9-1"))
                    viewModel.buttonTap(.two)
                    expect(viewModel.transferString).to(equal("9-12"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("-3"))
                    expect(viewModel.transferValue).to(equal(0.0))
                    
                    viewModel.buttonTap(.subtract)
                    expect(viewModel.transferString).to(equal("-3-"))
                    viewModel.buttonTap(.three)
                    expect(viewModel.transferString).to(equal("-3-3"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("-6"))
                    expect(viewModel.transferValue).to(equal(0.0))
                }
                
                it("multiply") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.transferString).to(equal("9"))
                    viewModel.buttonTap(.multiply)
                    expect(viewModel.transferString).to(equal("9x"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("9"))
                    expect(viewModel.transferValue).to(equal(0.0))
                }
                
                it("divide") {
                    viewModel.setEditType(isEditAmount: false)
                    
                    viewModel.buttonTap(.nine)
                    expect(viewModel.transferString).to(equal("9"))
                    viewModel.buttonTap(.divide)
                    expect(viewModel.transferString).to(equal("9÷"))
                    viewModel.buttonTap(.ok)
                    expect(viewModel.transferString).to(equal("9"))
                    expect(viewModel.transferValue).to(equal(0))
                    viewModel.buttonTap(.clear)
                    expect(viewModel.transferString).to(equal("0"))
                }
            }
            
            context("tap ok when zero") {
                it("should do nothing with amount") {
                    viewModel.buttonTap(.ok)
                    
                    expect(viewModel.amountString).to(equal("0"))
                }
                
                it("should do nothing with transfer fee") {
                    viewModel.setEditType(isEditAmount: false)
                    viewModel.buttonTap(.ok)
                    
                    expect(viewModel.amountString).to(equal("0"))
                }
            }
            
            context("delete to zero") {
                it("value should be zero with amount") {
                    viewModel.buttonTap(.one)
                    expect(viewModel.amountString).to(equal("1"))
                    viewModel.buttonTap(.two)
                    expect(viewModel.amountString).to(equal("12"))
                    viewModel.buttonTap(.del)
                    expect(viewModel.amountString).to(equal("1"))
                    viewModel.buttonTap(.del)
                    expect(viewModel.amountString).to(equal("0"))
                }
                
                it("value should be zero with transfer fee") {
                    viewModel.setEditType(isEditAmount: false)
                    viewModel.buttonTap(.one)
                    expect(viewModel.transferString).to(equal("1"))
                    viewModel.buttonTap(.two)
                    expect(viewModel.transferString).to(equal("12"))
                    viewModel.buttonTap(.del)
                    expect(viewModel.transferString).to(equal("1"))
                    viewModel.buttonTap(.del)
                    expect(viewModel.transferString).to(equal("0"))
                }
            }
        }
    }
}
