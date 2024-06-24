//
//  ScanExpenseSuccessPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 24/06/24.
//

import SwiftUI

struct ScanExpenseSuccessPage: View {
    @EnvironmentObject var nav: ScanExpenseNavigationViewModel

    @State private var isAnimate = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var rootDismiss: DismissAction? = nil
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                nav.path.removeAll()
//                if rootDismiss != nil {
//                    print("Root Dismiss is available!")
//                    rootDismiss?()
//                }
//                rootDismiss?()
//                nav.shouldGoBack = true
//                nav.presentationMode?.dismiss()
//                nav.dismiss?()
//                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ScanExpenseSuccessPage()
        .environmentObject(ScanExpenseNavigationViewModel())

}
