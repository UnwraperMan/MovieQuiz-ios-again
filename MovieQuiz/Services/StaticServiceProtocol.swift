//
//  StaticServiceProtocol.swift
//  MovieQuiz
//

import Foundation

protocol StaticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestResult: GameRecord { get }
}
