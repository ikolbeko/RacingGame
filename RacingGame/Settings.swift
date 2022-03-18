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
}
