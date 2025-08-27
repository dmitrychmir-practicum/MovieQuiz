import UIKit

final class MovieQuizViewController: UIViewController {
   
    // MARK: - Outlets
    
    @IBOutlet
    private weak var noButton: UIButton!
    @IBOutlet
    private weak var yesButton: UIButton!
    @IBOutlet
    private weak var questionTitleLabel: UILabel!
    @IBOutlet
    private weak var counterLabel: UILabel!
    @IBOutlet
    private weak var textLabel: UILabel!
    @IBOutlet
    private weak var imageView: UIImageView!
    
    // MARK: - Variables and constants
    
    private lazy var baseFont = UIFont(name: "YSDisplay-Medium", size: 20)
    private lazy var boldFont = UIFont(name: "YSDisplay-Bold", size: 23)
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private lazy var statisticService: StatisticServiceProtocol = StatisticService()
    private lazy var alertPresenter = AlertPresenter()
    private let oneSecond = 1.0
    private let zeroPointOneSecond = 0.1
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noButton.titleLabel?.font = baseFont
        yesButton.titleLabel?.font = baseFont
        questionTitleLabel.font = baseFont
        counterLabel.font = baseFont
        textLabel.font = boldFont
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        self.questionFactory?.initGame()
        self.questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Public functions
    
    func showCurrentQuestion(question: QuizQuestion) {
        currentQuestionIndex += 1
        currentQuestion = question
        imageView.layer.borderWidth = 0
        let viewModel = convert(question)
        show(quiz: viewModel)
    }
    
    // MARK: - Private functions
    
    private func toggleEnableButtons() {
        noButton.isEnabled = !noButton.isEnabled
        yesButton.isEnabled = !yesButton.isEnabled
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func convert(_ quiz: QuizQuestion) -> QuizStepViewModel {
        let image: UIImage = UIImage(named: quiz.image) ?? UIImage()
        let result = QuizStepViewModel(image: image,
                                       question: quiz.text,
                                       questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
        return result
    }
    
    private func validateAnswer(answer: Bool) -> Bool {
        guard let currentQuestion = currentQuestion else {
            return false
        }
        guard currentQuestion.correctAnswer == answer else {
            return false
        }
        correctAnswers += 1
        return true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        toggleEnableButtons()
        let delay = currentQuestionIndex == questionsAmount ? zeroPointOneSecond : oneSecond
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self else { return }
            self.toggleEnableButtons()
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex < questionsAmount {
            self.questionFactory?.requestNextQuestion()
        } else {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let model = createQuizResultsViewModel()
            showAlert(quiz: model)
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        self.questionFactory?.initGame()
        self.questionFactory?.requestNextQuestion()
    }
    
    private func createQuizResultsViewModel() -> QuizResultsViewModel {
        let bestGame = statisticService.bestGame
        let result: QuizResultsViewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(questionsAmount) (\(bestGame.date.dateTimeString))
            Средняя точность: \(statisticService.totalAccuracy.toPercentage)
""",
            buttonText: "Сыграть ещё раз")
        return result
    }
    
    private func showAlert(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.restartQuiz()
        }
        
        alertPresenter.showAlert(in: self, model: model)
    }
    
    // MARK: - Actions
    
    @IBAction
    private func noButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: validateAnswer(answer: false))
    }
    
    @IBAction
    private func yesButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: validateAnswer(answer: true))
    }
}
