//
//  SetCategoryView.swift
//  HoneyDue
//
//  Created by Fristania Verenita on 26/06/24.
//

import SwiftUI

struct CategoryIcon: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let color: Color
    var isSelected: Bool = false
}

struct SetCategoryView: View {
    
    // belom suain, g ngerti punya arya :)
    @State private var categories: [CategoryIcon] = [
        CategoryIcon(icon: "fork.knife", label: "Food", color: Color(hex: "B39EB5")),
        CategoryIcon(icon: "car", label: "Transport", color: Color(hex: "36A2EB")),
        CategoryIcon(icon: "bag", label: "Health", color: Color(hex: "FFCE56")),
        CategoryIcon(icon: "doc.text", label: "Bills", color: Color(hex: "4BC0C0")),
        CategoryIcon(icon: "heart", label: "Health", color: Color(hex: "9966FF")),
        CategoryIcon(icon: "gamecontroller", label: "Hobby", color: Color(hex: "FF9F40")),
        CategoryIcon(icon: "airplane", label: "Travel", color: Color(hex: "FF6384")),
        CategoryIcon(icon: "gift", label: "Gifts", color: Color(hex: "36A2EB")),
        CategoryIcon(icon: "book", label: "Education", color: Color(hex: "FFCE56")),
        CategoryIcon(icon: "banknote", label: "Savings", color: Color(hex: "4BC0C0"))
    ]
    
    @State private var showSetBudgetView = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SetBudgetView(selectedCategories: selectedCategories).presentationDetents([.fraction(0.5)]), isActive: $showSetBudgetView) {
                    EmptyView()
                }
                //            Spacer()
                
                VStack {
                    Text("Select Your Categories!")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    Text("Choose the categories that best represent your spending habits. We’ve included some common ones to get you started, but worry not, you can edit it later!")
                        .font(.system(size: 12, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .frame(width: 327, alignment: .top)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 24), count: 4), spacing: 24) {
                        ForEach(categories.indices, id: \.self) { index in
                            let category = categories[index]
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(category.color)
                                        .frame(width: 60, height: 60)
                                    // ini overlaynt ms belom sama kea di figma
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black.opacity(0.2), lineWidth: category.isSelected ? 4 : 0)
                                        )
                                        .onTapGesture {
                                            toggleSelection(index: index)
                                        }
                                    
                                    Image(systemName: category.icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                                
                                Text(category.label)
                                    .font(.system(size: 12, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    Button {
                        showSetBudgetView = true
                    } label: {
                        CustomButtonView(title: "Next")
                    }
                    .disabled(selectedCategories.isEmpty)
                    .opacity(selectedCategories.isEmpty ? 0.6 : 1.0)
                    .padding(.bottom, 20)
//                    .sheet(isPresented: $showSetBudgetView) {
//                        SetBudgetView(selectedCategories: selectedCategories)
//                    }
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                
            }
        }
//        .background(Color.gray)
//        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var selectedCategories: [CategoryBudget] {
        categories.filter { $0.isSelected }.map {
            CategoryBudget(icon: $0.icon, label: $0.label, color: $0.color, budget: "")
        }
    }
    
    private func toggleSelection(index: Int) {
        categories[index].isSelected.toggle()
    }
    
}


struct SetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SetCategoryView()
    }
}

