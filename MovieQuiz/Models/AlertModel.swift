//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 21.08.2025.
//

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
