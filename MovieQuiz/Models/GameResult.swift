//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 25.08.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func betterThan(_ other: GameResult) -> Bool {
        return correct > other.correct
    }
}
