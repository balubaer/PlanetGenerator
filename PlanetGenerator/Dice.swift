//
//  Dice.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Dice {
    var sides: Int
    
    init() {
        self.sides = 0
    }
    
    init(sides: Int) {
        self.sides = sides
    }
    
    func setSites(_ aSides: Int) {
        self.sides = aSides
    }
    
    func roll() -> Int {
        let resultRandom = Int(arc4random_uniform(UInt32(sides)))
            
        let result = resultRandom + 1

        return result
    }
}

