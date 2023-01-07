//
//  StaticServiceProtocol.swift
//  MovieQuiz
//

import Foundation

protocol StatsiticServiceProtocol {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
