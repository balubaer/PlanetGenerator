//
//  Dice.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Dice {
    let sides: Int
    init(sides: Int) {
        self.sides = sides
    }
    func roll() -> Int {
        var resultRandom = Int(arc4random_uniform(UInt32(sides)))
            
        var result = resultRandom + 1
        //println( "roll: \(result)")

        return result
    }
}

