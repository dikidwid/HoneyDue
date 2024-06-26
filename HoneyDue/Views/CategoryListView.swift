//
//  ListView.swift
//  HoneyDue
//
//  Created by Benedick Wijayaputra on 26/06/24.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    @Environment(\.dismiss) var dismiss
    let categories: [Category]
    
    var body: some View {
        VStack {
//            TopBarBack(title: "Category List")

            ScrollView {
                ForEach(categories) { category in
                    CategoryRowView(category: category)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
                .padding(.top, 6)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Category List")
        .padding([.horizontal])
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                        .frame(width: 17, height: 17)
                }
                .padding(.leading)
            }
        }       
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        CategoryListView(categories: Category.categories)
    }
}
