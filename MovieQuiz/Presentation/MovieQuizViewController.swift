import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    // MARK: - Lifecycle
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    @IBAction func noButton(_ sender: UIButton) {
        noButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButton(_ sender: UIButton) {
        yesButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private var alert: AlertPresenterProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var staticService: StaticService?
    
    private var currentQuestionIndex: Int = 0
    private var corectAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    private enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    private func string(from documentURL: URL) throws -> String {
        if !FileManager.default.fileExists(atPath: documentURL.path) {
            throw FileManagerError.fileDoesntExist
        }
        return try String(contentsOf: documentURL)
    }
    
    struct Actor: Codable {
        let id: String
        let image: String
        let name: String
        let asCharacter: String
    }
    
    struct Movie: Codable {
        let id: String
        let rank: String
        let title: String
        let fullTitle: String
        let year: String
        let image: String
        let crew: String
        let imDbRating: String
        let imDbRatingCount: String
    }
    
    struct Top: Decodable {
        let items: [Movie]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonFile = "top250MoviesIMDB.json"
        documentURL.appendPathComponent(jsonFile)
        
        var jsonString: String = ""
        
        do {
            jsonString = try string(from: documentURL)
        } catch FileManagerError.fileDoesntExist {
            print("По адресу \(documentURL.path) нет файла!")
        } catch {
            print("Ошибка \(error)")
        }
        
        guard let data = jsonString.data(using: .utf8) else { return }
        
        do {
            let result = try JSONDecoder().decode(Top.self, from: data)
        } catch {
            print("Ошибка распоковки!")
        }
        
        questionFactory = QuestionFactory(delegate: self)
        self.questionFactory?.requestNextQuestion()
        alert = AlertPresenter(controller: self)
        staticService = StaticServiceImplementation()
    }
    
    //MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    

    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            corectAnswers += 1
        }
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuesionOrResult()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    private func showNextQuesionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            staticService?.store(correct: corectAnswers, total: questionsAmount)
            guard let gamesCount = staticService?.gamesCount else {
                return
            }
            guard let bestResult = staticService?.bestResult else {
                return
            }
            guard let totalAccuracy = staticService?.totalAccuracy else {
                return
            }
            

            let text = "Ваш результат: \(corectAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestResult.correct)/\(bestResult.total) \(bestResult.date.dateTimeString) \nСредняя точность: \(String(format: "%.2f", totalAccuracy))%"
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще?") {
                    self.currentQuestionIndex = 0
                    self.corectAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            alert?.show(result: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
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
