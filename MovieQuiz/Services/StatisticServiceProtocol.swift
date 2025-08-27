//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 25.08.2025.
//

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
