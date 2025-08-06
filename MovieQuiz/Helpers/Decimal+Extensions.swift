//
//  Decimal+Extensions.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 05.08.2025.
//

import Foundation

extension Decimal {
    var toStringWith2Zero: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        let number = NSDecimalNumber(decimal: self)
        let formattedValue = formatter.string(from: number)!
        return formattedValue
    }
}
