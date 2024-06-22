//
//  ScanBillViewModel.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 20/06/24.
//

import Foundation

class ScanExpenseViewModel: ObservableObject {
    @Published var expenseResult: ScanExpenseResult = ScanExpenseResult.getExample()
    @Published var isSelectAll: Bool = false {
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
}
