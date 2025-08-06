//
//  QuizQuestion+Extensions.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 05.08.2025.
//

import UIKit

extension QuizQuestion {
    func toViewModel(_ questionNumber: String) -> QuizStepViewModel {
        let image: UIImage = UIImage(named: self.image) ?? UIImage()
        let result = QuizStepViewModel(image: image,
                                       question: self.text,
                                       questionNumber: questionNumber)
        return result
    }
}
