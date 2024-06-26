//
//  ScanExpenseSelectTransactionPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 21/06/24.
//

import SwiftUI

struct ScanExpenseSelectTransactionPage: View {
    @EnvironmentObject var nav: ScanExpenseNavigationViewModel
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel = ScanExpenseSelectTransactionViewModel(
        expenseResult: ScanExpenseResult.getExample()
    )
    @State private var shouldNextPage: Bool = false
    
    @State var customNotification: Notification = .successAddExpense
    @State var isShowCustomNotification: Bool = false
    @State var isDisableButton: Bool = false
    
    var body: some View {
        ScrollView {
//            NavigationLink(destination: ScanExpenseSuccessPage(), isActive: $shouldNextPage) {
//                EmptyView()
//            }
            VStack(alignment: .leading) {
                TopBarBack(title: "Your Receipt")

                Text("Choose the item and the amount you want to add to your expense. You can also edit the category here.")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .opacity(0.3)
                
                Group {
                    VStack(spacing: 16) {
                        ForEach(viewModel.expenseResult.items.indices, id: \.self) { index in
                            ExpenseTransactionItemView(
                                viewModel: viewModel,
                                item: $viewModel.expenseResult.items[index],
                                isChecked: $viewModel.expenseResult.items[index].isSelected
                            )
                            Rectangle()
                                .frame(height: 1)
                                .opacity(0.1)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.top, 2)
                
                HStack {
                    Checkbox(isChecked: $viewModel.isSelectAll)
                    Text("Select All")
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    saveExpense()
                }) {
                    Text("Save")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.colorPrimary)
                        .cornerRadius(16)
                }
                .background(Color(UIColor.systemGray6))
                .edgesIgnoringSafeArea(.all)
                .padding(.top)
                .disabled(isDisableButton)
                .opacity(isDisableButton ? 0.5 : 1.0)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.onIndividualCheckboxChange()
        }
        .overlay {
            NotificationView(notification: customNotification)
                .shadow(color: .black.opacity(0.5), radius: 10)
                .frame(maxHeight: .infinity, alignment: .top)
                .offset(y: isShowCustomNotification ? 0 : -150)
                .animation(.interpolatingSpring, value: isShowCustomNotification)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func saveExpense() {
//        shouldNextPage = true
//        nav.path.append(ScanExpenseNavigationDestination.success)
        
        let expenses = viewModel.expenseResult.getItemsAsExpense()
        for e in expenses {
            modelContext.insert(e)
        }
        
        isShowCustomNotification = true
        isDisableButton = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isShowCustomNotification = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            nav.path.removeLast(nav.path.count)
            isDisableButton = false
        }
    }
    
}

struct ExpenseTransactionItemView: View {
    @ObservedObject var viewModel: ScanExpenseSelectTransactionViewModel
    @Binding var item: ScanExpenseItem
    @Binding var isChecked: Bool
    
    let showIcon: Bool = true
    let isEditing: Bool = true
    
    // Add a state variable to control the presentation of the bottom sheet
    @State private var showBottomSheet: Bool = false
    
    var body: some View {
        let itemCategory = item.getCategory()
        
        HStack {
            if showIcon {
                ZStack {
                    Circle()
                        .foregroundStyle(itemCategory.color)
                        .opacity(1)
                        .frame(width: 52, height: 52)
                    Image(systemName: itemCategory.icon)
                        .foregroundStyle(.white)
                        .scaleEffect(1.2)
                }
                .padding(.trailing, 5)
                // Add a tap gesture to the icon
                .onTapGesture {
                    showBottomSheet = true
                }
                // Add a bottom sheet that is presented when the icon is tapped
                .sheet(isPresented: $showBottomSheet) {
                    VStack {
                        CategoryGrid(item: $item, showBottomSheet: $showBottomSheet)
                    }
                    .presentationDetents([.height(350), .medium, .large])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(24)
                    .padding()
                    .padding(.top)
                }
            }
            
            VStack(alignment: .leading) {

                HStack {
                    Text(item.name)
                        .fontWeight(.bold)
                        .opacity(0.9)
                    Spacer()
                    Checkbox(isChecked: $isChecked)
                        
                }
                
                HStack {
                    Text(item.getPricePerQtyIDR(includeTax: true).toIDRString())
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                
                    Spacer()
                    if isEditing && item.qty != 1 {
                        TextField("Quantity", value: $item.qty, format: .number)
                            .keyboardType(.decimalPad)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                            .textFieldStyle(CustomTextFieldStyle())
                            .frame(width: 50)
                    } else {
                        ZStack {
                            Text("x\(Int(item.qty))")
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
                                .frame(width: 50, alignment: .leading)
                            TextField("Quantity", value: $item.qty, format: .number)
                                .keyboardType(.decimalPad)
                                .opacity(0.0)
                                .textFieldStyle(CustomTextFieldStyle())
                                .frame(width: 50)
                        }
                    }
                    Spacer()
                    Text(item.getPriceTimesQtyIDR(includeTax: true).toIDRString())
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct Checkbox: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            self.isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .colorPrimary : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.2)
    }
}

struct CategoryGrid: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    @Binding var item: ScanExpenseItem
    @Binding var showBottomSheet: Bool

    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(TransactionCategory.categories, id: \.name) { category in
                CategoryItemView(category: category, item: $item, showBottomSheet: $showBottomSheet)
            }
        }
        .padding()
    }
}

struct CategoryItemView: View {
    var category: TransactionCategory
    @Binding var item: ScanExpenseItem
    @Binding var showBottomSheet: Bool

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundStyle(category.getColor())
                    .opacity(1)
                    .frame(width: 60, height: 60)
                Image(systemName: category.icon)
                    .foregroundStyle(.white)
                    .scaleEffect(1.4)
            }
            .onTapGesture {
                item.categoryString = category.name
                print("Category changed to: \(item.categoryString)")
                showBottomSheet = false
            }
            Text(category.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    NavigationStack {
        ScanExpenseSelectTransactionPage()
    }
    .environmentObject(ScanExpenseNavigationViewModel())

}
