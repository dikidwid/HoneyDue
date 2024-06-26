//
//  ConfirmationView.swift
//  HoneyDue
//
//  Created by Fristania Verenita on 26/06/24.
//

import SwiftUI

struct ConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var selectedCategories: [CategoryBudget]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            BackButtonView()
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    VStack {
                        Text("Track and Save!")
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.top, 20)
                        
                        Text("You’re all set! Start tracking your expenses and watch your savings grow. Remember, Honeydue is here to help you every step of the way.")
                            .font(.system(size: 12, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .frame(width: 327, alignment: .top)
                            .padding(.top, 8)
                            .padding(.bottom, 24)
                        
                        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 24), count: 4), spacing: 24) {
                            ForEach(selectedCategories.indices, id: \.self) { index in
                                let category = selectedCategories[index]
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(category.color)
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: category.icon)
                                            .font(.system(size: 24))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(category.label)
                                        .font(.system(size: 12, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                                    
                                    Text(Int(category.budget) ?? 0, format: .number)
                                        .font(.system(size: 12, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                                        .frame(width: 64, height: 12)
                                        .padding(.horizontal, 8)
                                        .background(Color.clear)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                        
                        Button {
                            // Action for the confirm button
                        } label: {
                            CustomButtonView(title: "Finish")
                        }
                        .padding(.bottom, 20)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                }
                .background(Color.gray)
                .edgesIgnoringSafeArea(.bottom)
            }
            
        }
        .navigationBarHidden(true)
    }
    

}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(selectedCategories: [
            CategoryBudget(icon: "fork.knife", label: "Food", color: Color(hex: "B39EB5"), budget: "1000000"),
            CategoryBudget(icon: "car", label: "Transport", color: Color(hex: "36A2EB"), budget: "500000")
        ])
    }
}
