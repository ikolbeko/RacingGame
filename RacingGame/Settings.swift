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
    
    var playerCar = "car2"
    
    //let
    
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
        for (index, value) in carArray.enumerated() {
            if playerCar == value && value != carArray.last {
                playerCar = carArray[index + 1]
                break
            }
            if value == carArray.last {
                playerCar = carArray[0]
            }
        }
    }
}
