import SwiftUI

struct ItemViewTapArea: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var category: Category
    @Binding var selectedCategory: Category
    @Binding var isEditMode: Bool
    var calculatedPosition: CGPoint
    
    var body: some View {
        ZStack {
            Image(category.item.image)
                .renderingMode(isEditMode && !category.isEnable ? .template : .original)
                .resizable()
                .scaledToFit()
                .frame(width: category.item.width)
                .position(calculatedPosition)
                .opacity(isEditMode && !category.isEnable ? 0.5 : category.isEnable ? 0.01 : 1)
                .onTapGesture {
                    if self.isEditMode {
                        category.isEnable.toggle()
                    } else if category.isEnable {
                        homeViewModel.selectedCategory = category
                        homeViewModel.isShowDetailCategory = true
                        print(selectedCategory)
                    }
                }
            
            if self.isEditMode {
                Image(systemName: category.isEnable ? "minus.circle.fill" : "plus.circle.fill")
                    .foregroundColor(category.isEnable ? .red : .blue)
                    .background(Circle().fill(Color.white))
                    .position(x: calculatedPosition.x, y: calculatedPosition.y)
                    .onTapGesture {
                        category.isEnable.toggle()
                    }
            }
            
        }
    }
}
