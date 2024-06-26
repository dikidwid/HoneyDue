//
//  Untitled.swift
//  HoneyDue
//
//  Created by Arya Adyatma on 25/06/24.
//

import SwiftUI

struct NavStack: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            PageA(path: $path)
                .navigationDestination(for: String.self) { page in
                    switch page {
                    case "B":
                        PageB(path: $path)
                    case "C":
                        PageC(path: $path)
                    default:
                        EmptyView()
                    }
                }
        }
    }
}

struct PageA: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Page A")
                .font(.largeTitle)
            
            Button("Go to Page B") {
                path.append("B")
            }
        }
    }
}

struct PageB: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Page B")
                .font(.largeTitle)
            
            Button("Go to Page C") {
                path.append("C")
            }
        }
    }
}

struct PageC: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Page C")
                .font(.largeTitle)
            
            Button("Go Home") {
                path.removeLast(path.count)
            }
        }
    }
}


#Preview {
    NavStack()
}
