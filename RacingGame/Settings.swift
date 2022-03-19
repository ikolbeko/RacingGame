//
//  Settings.swift
//  RacingGame
//
//  Created by Илья Колбеко on 18.03.22.
//

import Foundation

class Settings {
    static let sharedInstance = Settings()
    
    private init() {}
    var highScore = 0
    
    var playerCar = "car1"
    var level = "medium"
    
    let levelArray = ["easy", "medium", "hard"]
    
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
    }
    
    func changeLevel() {
        level = change(array: levelArray, varible: level)
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
