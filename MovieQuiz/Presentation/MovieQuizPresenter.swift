//
//  MovieQuizPresenter.swift
//  MovieQuiz
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    private var currentQuestion: QuizQuestion?
    private var viewController: MovieQuizViewControllerProtocol?
    
    private var correctAnswers: Int = 0 //
    private var questionFactory: QuestionFactoryProtocol? = nil//
    var alertPresenter: AlertPresenterProtocol? = nil//
    private let statisticService: StatisticServiceImplementation? //
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func proceedToNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard
                let bestGame = statisticService?.bestGame,
                let gamesCount = statisticService?.gamesCount,
                let totalAccuracy = statisticService?.totalAccuracy
            else {
                return
            }
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: """
                        Ваш результат: \(self.correctAnswers)/\(questionsAmount)
                        Количество сыгранных квизов: \(gamesCount)
                        Рекорд: \(bestGame.correct)/\(bestGame.total)/(\(bestGame.date.dateTimeString))
                        Средняя точность: \(String(format: "%.2f", statisticService!.totalAccuracy))%
                        """,
                buttonText: "Сыграть ещё раз") {
                    self.restartGame()
                    self.questionFactory?.requestNextQuestion()
                }
            alertPresenter?.showAlert(result: alertModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
}
