//
//  Fleet.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Fleet: Comparable, Equatable {
    var number: Int = 0
    var name: String {
        var desc = "F\(number)"
        if player != nil {
            desc += player!.description
        } else {
            desc += "[---]"
        }
        return desc
    }
    var ships: Int = 0
    var player: Player?
    
    var description: String {
        var desc = "\(name) = \(ships)"
        return desc
    }
    
    init() {
    }
    
}

func <=(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber <= rNumber
    return result
}

func >=(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber >= rNumber
    return result
}

func >(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber > rNumber
    
    return result
}

func <(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber < rNumber
    
    return result
}

func ==(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber == rNumber
    
    return result
}
