import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
   
    
    
    
    // MARK: - Lifecycle
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
//    private var questionFactory: QuestionFactoryProtocol?
//    private var currentQuestion: QuizQuestion?
//    private var statisticService: StatisticServiceImplementation?
//
//    private var currentQuestionIndex: Int = 0
//    private var correctAnswers: Int = 0
//    private let questionsAmount: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
//             questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
//             questionFactory?.loadData()
//             showLoadingIndicator()
             alertPresenter = AlertPresenter(alertController: self)
             presenter = MovieQuizPresenter(viewController: self)
//             statisticService = StatisticServiceImplementation()
        
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        presenter.noButtonClicked()
//        noButton.isEnabled = false
//
//        guard let currentQuestion = currentQuestion else { return }
//        let givenAnswer = false
//
//        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        presenter.yesButtonClicked()
//        yesButton.isEnabled = false
//
//        guard let currentQuestion = currentQuestion else { return }
//        let givenAnswer = true
//
//        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        guard let question = question else {
//            return
//        }
//        currentQuestion = question
//        let viewModel = convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
//    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
         imageView.layer.masksToBounds = true
         imageView.layer.borderWidth = 8
         imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
         imageView.layer.cornerRadius = 20
         
         noButton.isEnabled = false
         yesButton.isEnabled = false
         
         self.presenter.alertPresenter = self.alertPresenter
     }
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
//    private func showAnswerResult(isCorrect: Bool) {
//        if isCorrect {
//            correctAnswers += 1
//        }
//        imageView.layer.borderWidth = 8
//        imageView.layer.cornerRadius = 20
//        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self = self else { return }
//
//            self.showNextQuesionOrResult()
//            self.imageView.layer.borderColor = UIColor.clear.cgColor
//        }
//    }
    
//    private func showNextQuesionOrResult() {
//        if currentQuestionIndex == questionsAmount - 1 {
//            
//            statisticService?.store(correct: correctAnswers, total: questionsAmount)
//            guard let gamesCount = statisticService?.gamesCount else {
//                return
//            }
//            guard let bestGame = statisticService?.bestGame else {
//                return
//            }
//            guard let totalAccuracy = statisticService?.totalAccuracy else {
//                return
//            }
//            
//            let alertModel = AlertModel(
//                title: "Этот раунд окончен!",
//                message: """
//                        Ваш результат: \(correctAnswers)/\(questionsAmount)
//                        Количество сыгранных квизов: \(gamesCount)
//                        Рекорд: \(bestGame.correct)/\(bestGame.total)/(\(bestGame.date.dateTimeString))
//                        Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%
//                        """,
//                buttonText: "Сыграть еще раз?") {
//                    self.currentQuestionIndex = 0
//                    self.correctAnswers = 0
//                    self.questionFactory?.requestNextQuestion()
//                }
//            alertPresenter?.showAlert(result: alertModel)
//        } else {
//            currentQuestionIndex += 1
//            questionFactory?.requestNextQuestion()
//        }
//    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
          activityIndicator.stopAnimating()
          activityIndicator.isHidden = true
      }
    
    func showNetworkError(message: String) {
         hideLoadingIndicator()
         let alertModel = AlertModel(
             title: "Ошибка",
             message: message,
             buttonText: "Попробовать ещё раз",
             completion: { [weak self]  in
                 guard let self = self else {
                     return
                 }
                 self.presenter.restartGame()
//                 self.correctAnswers = 0
//                 self.currentQuestionIndex = 0
//                 self.questionFactory?.requestNextQuestion()
             })
         alertPresenter?.showAlert(result: alertModel)
     }
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true
//        questionFactory?.requestNextQuestion()
//    }
    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
