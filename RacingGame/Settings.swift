//
//  Settings.swift
//  RacingGame
//
//  Created by Илья Колбеко on 18.03.22.
//

import Foundation

class Settings {
    
    enum Level: String {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
    }
    
    static let sharedInstance = Settings()
    
    private init() {
        if let levelRawValue = UserDefaults().string(forKey: "level") {
            level = Level(rawValue: levelRawValue) ?? .easy
        }
        if let playerCarUD = UserDefaults().string(forKey: "playerCar") {
            playerCar = playerCarUD
        }
        highScore = UserDefaults().integer(forKey: "GameHighScore")
    }
    var highScore = 0
    
    var playerCar = "car1"
    var level: Level = .easy
    
    let carArray = [
        "car1",
        "car2",
        "car3",
        "car4",
        "car5",
        "car6",
        "car7",
        "car8"
    ]
    
    func changePlayerCar() {
        playerCar = change(array: carArray, varible: playerCar)
        UserDefaults.standard.set(playerCar, forKey: "playerCar")
    }
    
    func changeLevel() {
        switch level {
        case .easy:
            level = .medium
        case .medium:
            level = .hard
        case .hard:
            level = .easy
        }
        UserDefaults.standard.set(level.rawValue, forKey: "level")
    }
    
    private func change(array: [String], varible: String) -> String {
        var temp = varible
        
        for (index, value) in array.enumerated() {
            if varible == value && value != array.last {
                temp = array[index + 1]
                break
            }
            if value == array.last {
                temp = array[0]
            }
        }
        return temp
    }
}
