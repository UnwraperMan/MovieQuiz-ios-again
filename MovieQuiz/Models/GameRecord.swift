//
//  GameRecord.swift
//  MovieQuiz
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compare(source cmpr: GameRecord) -> Bool {
        self.correct < cmpr.correct
    }
}
