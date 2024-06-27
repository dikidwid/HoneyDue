import SwiftUI

struct CategoryBudget: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let color: Color
    var budget: String
}

// Custom numeric textfield
struct BudgetTextField: View {
    @Binding var budget: String
    
    var body: some View {
        VStack(spacing: 8) {
            TextField("500.000", text: $budget)
                .font(.system(size: 10, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                .frame(width: 64, height: 25)
                .padding(.horizontal, 8)
                .background(Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1))
                .keyboardType(.decimalPad)
                .onChange(of: budget) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        budget = filtered
                    }
                }
        }
    }
}

struct BackButtonView: View {
    var body: some View {
        Image(systemName: "arrow.backward")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            .frame(width: 21, height: 22)
    }
}

struct SetBudgetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var selectedCategories: [CategoryBudget]
    @StateObject private var keyboardResponder = KeyboardResponder()
    @FocusState private var isFocused: Bool
    @State private var showConfirmationView = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Spacer()
                
                VStack {
                    Text("Set Your Budget!")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    Text("Now, let’s set a budget for each category. This will help you stay on track and meet your financial goals.")
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
                                
                                BudgetTextField(budget: $selectedCategories[index].budget)
                                    .focused($isFocused)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    
                    Button {
                        showConfirmationView = true
                    } label: {
                        CustomButtonView(title: "Next")
                    }
                    .disabled(!areAllBudgetsFilled)
                    .opacity(areAllBudgetsFilled ? 1.0 : 0.6)
                    .padding(.bottom, 20)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(24)
                .offset(y: calculateOffset())
                .navigationTitle("Set Budget")
                .navigationBarHidden(true)
                .background(
                    NavigationLink(destination: ConfirmationView(selectedCategories: selectedCategories), isActive: $showConfirmationView) {
                        EmptyView()
                    }
                )
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.3))
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
    
    private var areAllBudgetsFilled: Bool {
        !selectedCategories.contains { $0.budget.isEmpty }
    }
    
    private func calculateOffset() -> CGFloat {
        let keyboardHeight = keyboardResponder.currentHeight
        let screenHeight = UIScreen.main.bounds.height
        let visibleHeight = screenHeight - keyboardHeight
        
        let offset = visibleHeight - 54
        
        return isFocused ? -keyboardHeight * 0.8 : 0
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SetBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        SetBudgetView(selectedCategories: [
            CategoryBudget(icon: "fork.knife", label: "Food", color: Color(hex: "B39EB5"), budget: ""),
            CategoryBudget(icon: "car", label: "Transport", color: Color(hex: "36A2EB"), budget: "")
        ])
    }
}
