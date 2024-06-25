//
//  DummyData.swift
//  VisionAI
//
//  Created by Arya Adyatma on 19/06/24.
//

import Foundation

extension ScanExpenseResult {
    static func getExample() -> ScanExpenseResult {
        let items = [
            ScanExpenseItem(name: "Iced Sweet Lychee Tea", pricePerQtyIDR: 25000, qty: 2, emoji: "🍹", notes: "", categoryString: "food_and_beverage"),
            ScanExpenseItem(name: "Choco Motive", pricePerQtyIDR: 10000, qty: 2, emoji: "🍫", notes: "", categoryString: "food_and_beverage"),
            ScanExpenseItem(name: "Red", pricePerQtyIDR: 15000, qty: 1.25, emoji: "🍷", notes: "", categoryString: "food_and_beverage"),
            ScanExpenseItem(name: "Black", pricePerQtyIDR: 12000, qty: 1, emoji: "☕️", notes: "", categoryString: "food_and_beverage")
        ]
        return ScanExpenseResult(
            items: items,
            taxChargeIDR: 11200,
            serviceChargeIDR: 5000,
            othersChargeIDR: 0,
            discountsIDR: 0
        )
    }
    
    static func getFromAIResponse() -> ScanExpenseResult {
        let result: ScanExpenseResult? = ScanExpenseResult.fromJson(jsonString: aiResponse)
        print(result ?? "[Empty]")

        if result != nil {
            return result!
        }
        
        return ScanExpenseResult.getExample()
    }
}



let aiResponse = """

{
    "items": [
        {
            "name": "EAT ME BRAVO TM",
            "pricePerQtyIDR": 34800,
            "qty": 1,
            "emoji": "🍽️",
            "notes": "Discount applied: 1740",
            "categoryString": "Food"
        },
        {
            "name": "MELON SKY PTONG",
            "pricePerQtyIDR": 44000,
            "qty": 0.244,
            "emoji": "🍈",
            "notes": "Discount applied: 536",
            "categoryString": "Food"
        }
    ],
    "taxChargeIDR": 0,
    "serviceChargeIDR": 0,
    "othersChargeIDR": 0,
    "discountsIDR": 14820
}

""".replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
//
//
//let aiResponse = """
//
//{
//    "items": [
//        {
//            "name": "EAT ME BRAVO TM",
//            "pricePerQtyIDR": 34800,
//            "qty": 1,
//            "emoji": "🍽️",
//            "notes": "Discount applied: 1740",
//            "categoryString": "Food"
//        },
//        {
//            "name": "MELON SKY PTONG",
//            "pricePerQtyIDR": 44000,
//            "qty": 0.244,
//            "emoji": "🍈",
//            "notes": "Discount applied: 536",
//            "categoryString": "Food"
//        },
//        {
//            "name": "DANMUJI",
//            "pricePerQtyIDR": 8000,
//            "qty": 1,
//            "emoji": "🍽️",
//            "notes": "Discount applied: 400",
//            "categoryString": "Food"
//        },
//        {
//            "name": "MUSAENGCHAE",
//            "pricePerQtyIDR": 8500,
//            "qty": 1,
//            "emoji": "🍽️",
//            "notes": "Discount applied: 425",
//            "categoryString": "Food"
//        },
//        {
//            "name": "CHEDDAR CHEESE",
//            "pricePerQtyIDR": 5800,
//            "qty": 1,
//            "emoji": "🧀",
//            "notes": "Discount applied: 290",
//            "categoryString": "Food"
//        },
//        {
//            "name": "SOFF TISSUE 250",
//            "pricePerQtyIDR": 10800,
//            "qty": 1,
//            "emoji": "🧻",
//            "notes": "Item promo: 2300, Discount applied: 425",
//            "categoryString": "Food"
//        },
//        {
//            "name": "CF MCL YZ 250ML",
//            "pricePerQtyIDR": 28500,
//            "qty": 1,
//            "emoji": "🥤",
//            "notes": "Discount applied: 1425",
//            "categoryString": "Food"
//        },
//        {
//            "name": "NANAS MADU KPS",
//            "pricePerQtyIDR": 12000,
//            "qty": 2,
//            "emoji": "🍍",
//            "notes": "Discount applied: 1200",
//            "categoryString": "Food"
//        },
//        {
//            "name": "SKR TAHU TLR 16",
//            "pricePerQtyIDR": 13500,
//            "qty": 1,
//            "emoji": "🍽️",
//            "notes": "Discount applied: 675",
//            "categoryString": "Food"
//        },
//        {
//            "name": "DF BLACK THUNDE",
//            "pricePerQtyIDR": 2500,
//            "qty": 7,
//            "emoji": "🍫",
//            "notes": "Item promo: 2000, Discount applied: 700",
//            "categoryString": "Food"
//        }
//    ],
//    "taxChargeIDR": 0,
//    "serviceChargeIDR": 0,
//    "othersChargeIDR": 0,
//    "discountsIDR": 14820
//}
//
//""".replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
