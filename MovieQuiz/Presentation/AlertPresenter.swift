//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Чмир on 21.08.2025.
//

import UIKit

final class AlertPresenter {
    func showAlert(in controller: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let sction = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(sction)
        controller.present(alert, animated: true, completion: nil)
    }
}
