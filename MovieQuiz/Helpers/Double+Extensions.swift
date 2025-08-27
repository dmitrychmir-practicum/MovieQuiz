//
//  Double+Extensions.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 26.08.2025.
//

import Foundation

extension Double {
    var toPercentage: String {
        return "\(String(format: "%.2f", self))%"
    }
}
