//
//  HomeViewModel.swift
//  HoneyDue
//
//  Created by Singgih Tulus Makmud on 25/06/24.
//

import SwiftUI
import SwiftData

final class HomeViewModel: ObservableObject {
    @Published var shine: Bool = false
    @Published var selectedCategory: Category = .categories[0]
    @Published var isShowDetailCategory: Bool = false
    @Published var isShowAddExpenseView: Bool = false
    @Published var selectedCategoryEdit: Category? = nil
    @Published var showModal = false
    @Published var isEditMode = false
    @Published var showEditModal = false
    @Published var initialCategoriesState: [Category] = []
    @Published var categories: [Category] = []
    
    
    private let dataSource: CategoryDataSource
    
    init(dataSource: CategoryDataSource = CategoryDataSource.shared) {
        self.dataSource = dataSource
        categories = dataSource.fetchItems()
    }
    
    func cancelEditMode() {
        self.categories = self.initialCategoriesState
        self.isEditMode = false
    }
    
    func toggleEditMode() {
        if isEditMode {
            isEditMode.toggle()
        } else {
            initialCategoriesState = categories
            isEditMode = true
        }
    }
    
    func fetchCategories(from context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Category>()

        do {
            let results = try context.fetch(fetchDescriptor)
            categories = results
        } catch {
            print(error)
        }
    }
}

final class CategoryDataSource {
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    @MainActor
    static let shared = CategoryDataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: Category.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchItems() -> [Category] {
        do {
            let itemFetchDescriptor = FetchDescriptor<Category>()
            
//            guard try modelContext.fetch(itemFetchDescriptor).count == 0 else { return try! modelContext.fetch(itemFetchDescriptor) }
            
            // This code will only run if the persistent store is empty.
            Category.insertSampleData(modelContext: modelContext)
            
            return try modelContext.fetch(FetchDescriptor<Category>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

