import SwiftUI

struct ItemViewTapArea: View {
    @Binding var item: Item
    @Binding var isEditMode: Bool
    var calculatedPosition: CGPoint
    @Binding var isEnable: Bool
    
    var body: some View {
        ZStack {
            
            Image(item.image)
                .renderingMode(isEditMode && !isEnable ? .template : .original)
                .resizable()
                .scaledToFit()
                .frame(width: item.width)
                .position(calculatedPosition)
                .opacity(isEditMode && !isEnable ? 0.5 : isEnable ? 0.01 : 1)
                .onTapGesture {
                    if self.isEditMode {
                        isEnable.toggle()
                    } else if isEnable {
//                        AddExpenseView()
                    }
                }
            
            if self.isEditMode {
                Image(systemName: isEnable ? "minus.circle.fill" : "plus.circle.fill")
                    .foregroundColor(isEnable ? .red : .blue)
                    .background(Circle().fill(Color.white))
                    .position(x: calculatedPosition.x, y: calculatedPosition.y)
                    .onTapGesture {
                        isEnable.toggle()
                    }
            }
            
        }
    }
}
