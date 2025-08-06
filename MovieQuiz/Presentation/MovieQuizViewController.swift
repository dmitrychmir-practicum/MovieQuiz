import UIKit

final class MovieQuizViewController: UIViewController {
   
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var statistics: [QuizStat] = []
    private var questionNumber: String {
        return "\(currentQuestionIndex + 1)/\(questions.count)"
    }
    private let baseFont = UIFont(name: "YSDisplay-Medium", size: 20)
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noButton.titleLabel?.font = baseFont
        yesButton.titleLabel?.font = baseFont
        questionTitleLabel.font = baseFont
        counterLabel.font = baseFont
        textLabel.font = baseFont?.withSize(23)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        
        showCurrentQuestion()
    }
    
    private func toggleEnableButtons() {
        noButton.isEnabled = !noButton.isEnabled
        yesButton.isEnabled = !yesButton.isEnabled
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showCurrentQuestion() {
        imageView.layer.borderWidth = 0
        let viewModel = questions[currentQuestionIndex].toViewModel(questionNumber)
        show(quiz: viewModel)
    }
    
    private func validateAnswer(answer: Bool) -> Bool {
        guard questions[currentQuestionIndex].correctAnswer == answer else {
            return false
        }
        
        correctAnswers += 1
        return true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        toggleEnableButtons()
        let delay = currentQuestionIndex == questions.count - 1 ? 0.1 : 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.toggleEnableButtons()
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            statistics.append(QuizStat(correctAnswers: correctAnswers, quizFinished: Date().dateTimeString))
            var perfectResult: QuizStat = statistics[0]
            var sum: Int = 0
            for stat in statistics {
                if stat.correctAnswers > perfectResult.correctAnswers {
                    perfectResult = stat
                }
                sum += stat.correctAnswers
            }
            let average = Decimal(sum) / (Decimal(statistics.count * questions.count) / 100.0)
            let model = createQuizResultsViewModel(perfect: perfectResult, lastResult: statistics.last!, average: average)
            showAlert(quiz: model)
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        showCurrentQuestion()
    }
    
    private func createQuizResultsViewModel(perfect: QuizStat, lastResult: QuizStat, average: Decimal) -> QuizResultsViewModel {
        let result: QuizResultsViewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: "Ваш результат: \(lastResult.statistic(questions.count))\nКоличество сыгранных квизов: \(statistics.count)\nРекорд: \(perfect.statistic(questions.count)) (\(perfect.quizFinished))\nСредняя точность: \(average.toStringWith2Zero)%",
            buttonText: "Сыграть ещё раз")
        
        return result
    }
    
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.restartQuiz()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: validateAnswer(answer: false))
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: validateAnswer(answer: true))
    }
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

struct QuizStat {
    let correctAnswers: Int
    let quizFinished: String
}
