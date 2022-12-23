//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Unwraper Man on 22.12.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
