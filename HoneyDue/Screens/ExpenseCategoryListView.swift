//
//  ExpenseCategoryListView.swift
//  iTrack
//
//  Created by Diki Dwi Diro on 20/06/24.
//

import SwiftUI
import SwiftData

struct ExpenseCategoryListView: View {
    @State private var selectedCategory: Category? /*= Category.categories[0]*/
    @State private var isShowAddExpenseView: Bool = false
    @State private var notification: Notification?
    
    @Query(sort: \Category.name) private var categories: [Category]
    
    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                Label {
                    Text(category.name)
                        .padding(.leading)
                } icon: {
                    Image(systemName: category.icon)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.all, 10)
                        .background {
                            Circle()
                                .fill(category.color)
                        }
                }
                .padding(.horizontal)
                .onTapGesture {
                    selectedCategory = category
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            ExpenseDetailView(category: category, isShowAddExpense: $isShowAddExpenseView)
                .padding(.all, 5)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(.modalityCornerRadius)
                .presentationDetents([.fraction(0.7)])
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            ExpenseCategoryListView()
                .navigationTitle("Category")
        }
    }
}

