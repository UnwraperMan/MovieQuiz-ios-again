import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBAction func noButton(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer )
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let firstQuestion = questions.first else {
            return
        }
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
        
//        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            currentQuestionIndex += 1
        }
    }
    
    struct QuizStepViewModel {
        var image: UIImage
        var question: String
        var questionNumber: String
    }
    
    struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    struct QuizQuestion {
        var image: String
        var text: String
        var correctAnswer: Bool
    }
    
    let questions: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Dark Knight",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Kill Bill",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Avengers",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Deadpool",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Green Knight",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Old",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "Tesla",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "Vivarium",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false)
    ]
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
