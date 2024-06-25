//
//  ScanExpenseSuccessPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 24/06/24.
//

import SwiftUI

struct ScanExpenseSuccessPage: View {
    @EnvironmentObject var nav: ScanExpenseNavigationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnimate = false
    @State private var shouldGoBack = false
    
    var body: some View {
        VStack {

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 90, height: 90)
                .foregroundColor(.colorPrimary)
                .symbolEffect(.bounce.up.byLayer, options: .repeat(1), value: isAnimate)
            
            Text("Success!")
                .font(
                    Font.custom("SF Pro", size: 18)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .padding(.top)
        }
        .onAppear {
            isAnimate = true
//            shouldGoBack = true
//            nav.path.removeLast()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                nav.path.removeLast(nav.path.count)
//            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ScanExpenseSuccessPage()
        .environmentObject(ScanExpenseNavigationViewModel())

}
