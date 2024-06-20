//
//  ScanExpenseReadingPage.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 20/06/24.
//

import SwiftUI

struct ScanExpenseReadingPage: View {
    @State private var progress: Double = 0.5
    @State private var isBouncing = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
                .offset(y: isBouncing ? -5 : 5)
                .animation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                )
                .onAppear {
                    isBouncing = true
                }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 200, height: 6)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .cornerRadius(8)
                
                VStack {
                    Capsule()
                        .frame(width: 100, height: 6)
                        .foregroundColor(.gray)
                        .offset(x: progress)
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false)
                    )
                }
                .offset(x: -125)
                
            }
            .onAppear {
                progress = 350
            }
            .clipped()
            .cornerRadius(8)
            .padding(20)
            
            
            Text("Reading the bill")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("Please wait")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            Button(action: {
                // Add your cancel action here
            }) {
                Text("Cancel")
                    .font(.headline)
                    .frame(width: 100, height: 40)
                    .background(Color(UIColor.systemGray5))
                    .foregroundColor(.gray)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ScanExpenseReadingPage()
}