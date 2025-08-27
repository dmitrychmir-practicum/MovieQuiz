//
//  MovieQuizViewController+Extensions.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 27.08.2025.
//

import UIKit

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        DispatchQueue.main.async {
            [weak self] in
            self?.showCurrentQuestion(question: question)
        }
    }
}
