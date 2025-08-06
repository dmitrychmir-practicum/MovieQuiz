//
//  QuizStat+Extensions.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 05.08.2025.
//

extension QuizStat {
    func statistic(_ questionsCount: Int) -> String {
        return "\(self.correctAnswers)/\(questionsCount)"
    }
}
