//
//  cobaView.swift
//  minichallenge2
//
//  Created by Benedick Wijayaputra on 19/06/24.
//

import SwiftUI
import Charts

struct ChartData: Identifiable {
    let category: String
    let percentage: Double
    
    var id: String { return category }
}

func calculateSpendingPercentages(budgets: [String: Double], expenses: [String: Double], categories: [String]) -> [ChartData] {
    var percentages: [ChartData] = []
    
    for category in categories {
        if let budget = budgets[category], let expense = expenses[category] {
            let percentage = (expense / budget) * 100
            let cappedPercentage = min(percentage, 100.0)  // Cap the percentage at 100%
            percentages.append(ChartData(category: category, percentage: cappedPercentage))
        } else {
            percentages.append(ChartData(category: category, percentage: 0.0))
        }
    }
    
    return percentages
}

struct DonutView: View {
    let categories: [String]
    
    // Dummy data for budgets and expenses
    let budgets: [String: Double] 
//   = [
//        "Food": 500.0,
//        "Shopping": 400.0,
//        "Transport": 300.0,
//        "Travelling": 200.0,
//        "Health": 250.0,
//        "Hobby": 200.0
//    ]
    
    let expenses: [String: Double] 
//    = [
//        "Food": 250.0,
//        "Shopping": 150.0,
//        "Transport": 100.0,
//        "Travelling": 180.0,
//        "Health": 1000.0,
//        "Hobby": 100
//    ]
    
    var body: some View {
        let categoryOption = calculateSpendingPercentages(budgets: budgets, expenses: expenses, categories: categories)
        
        let totalPercentage = categoryOption.map { $0.percentage }.reduce(0, +)
        let angles = categoryOption.map { $0.percentage / totalPercentage * 360 }
        
        ZStack {
            Chart {
                ForEach(categoryOption.indices, id: \.self) { index in
                    SectorMark(angle: .value("Category", categoryOption[index].percentage),
                               innerRadius: .ratio(0.5),
                               angularInset: 0)
                    .foregroundStyle(getColor(for: categoryOption[index].category))
                }
            }
            
            ForEach(categoryOption.indices, id: \.self) { index in
                let angle = angles.prefix(index + 1).reduce(0, +) - angles[index] / 2
                let radius: CGFloat = 100 // Adjust this value to place the annotations outside the chart
                let xOffset = radius * cos(CGFloat(angle - 90) * .pi / 180)
                let yOffset = radius * sin(CGFloat(angle - 90) * .pi / 180)
                
                VStack {
                        Text("\(categoryOption[index].category)")
                            .font(.system(size: 10))
                        
                        Text("\(categoryOption[index].percentage, specifier: "%.f")%")
                            .font(.system(size: 10))
                            .fontWeight(.bold)
                    }
                    .multilineTextAlignment(.center)
                    .offset(x: xOffset, y: yOffset)
            }
        }
        .frame(height: 130)
        .padding()
    }
    
    private func getColor(for category: String) -> Color {
        switch category {
        case "Food":
            return .foodColor
        case "Transport":
            return .transportColor
        case "Health":
            return .healthColor
        case "Shopping":
            return .shoppingColor
        case "Travelling":
            return .travellingColor
        case "Education":
            return .educationColor
        case "Pet":
            return .petColor
        case "Utilities":
            return .utilitiesColor
        case "Hobby":
            return .hobbyColor
        case "Others":
            return .othersAndOverallColor
        default:
            return Color.gray
        }
    }
}

//struct DonutView_Previews: PreviewProvider {
//    static var previews: some View {
//        DonutView()
//    }
//}
