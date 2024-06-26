//
//  HoneyDueApp.swift
//  HoneyDue
//
//  Created by Diki Dwi Diro on 20/06/24.
//

import SwiftUI
import SwiftData

@main
@MainActor
struct HoneyDueApp: App {
    var container: ModelContainer {
        do {
            let container = try ModelContainer(for: Category.self)
            
            // Make sure the persistent store is empty. If it's not, return the non-empty container.
            var itemFetchDescriptor = FetchDescriptor<Category>()
            itemFetchDescriptor.fetchLimit = 1
            
            guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
            
            // This code will only run if the persistent store is empty.
            Category.insertSampleData(modelContext: container.mainContext)
            
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SetCategoryView()
        }
        .modelContainer(container)
    }
}
