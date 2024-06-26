import SwiftUI
import SwiftData

struct CategoryRowView: View {
    @State private var progressbarPercentage: Double = 1
    let category: Category
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(category.color)
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: category.icon)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.name)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(category.status)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 7) {
                        Text(Double(category.totalExpense), format: .currency(code: "IDR"))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(Double(category.remainingBudget), format: .currency(code: "IDR")) remains")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                ProgressBarView(progress: progressbarPercentage, isShowPercentage: false)
                    .frame(height: 4)

            }
            .padding([.vertical, .horizontal])
            .onAppear {
                progressbarPercentage = category.remainingBudgetPercentage
            }
        }
        .frame(width: 329, height: 92)
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        CategoryRowView(category: .categories[0])
    }
}
