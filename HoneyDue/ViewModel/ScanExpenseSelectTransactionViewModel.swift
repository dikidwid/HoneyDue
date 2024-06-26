//
//  ScanBillViewModel.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 20/06/24.
//

import Foundation

class ScanExpenseSelectTransactionViewModel: ObservableObject {
    @Published var expenseResult: ScanExpenseResult
    @Published var isSelectAll: Bool = true {
        didSet {
            if isSelectAll {
                for index in expenseResult.items.indices {
                    expenseResult.items[index].isSelected = true
                }
            } else {
                for index in expenseResult.items.indices {
                    expenseResult.items[index].isSelected = false
                }
            }
        }
    }
    
    func onIndividualCheckboxChange() {
        isSelectAll = expenseResult.items.allSatisfy { $0.isSelected }
    }
    
    init(expenseResult: ScanExpenseResult) {
        self.expenseResult = expenseResult
    }
    
}
