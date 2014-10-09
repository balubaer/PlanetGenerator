//
//  Planet.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Planet: Comparable, Equatable {
    var number: Int = 0
    var name: String
    var ports: Port?
    
    var description: String {
        var desc = "Planet Nummer: \(number) Name: \(name) "
        if ports != nil {
            desc = desc + ports!.description
        }
        return desc
    }
    
    init() {
        name = "NO Name"
    }
    
    func hasConnectionToPlanet(aPlant : Planet) -> Bool {
        var result = false
        if ports != nil {
            result = ports!.hasConnectionToPlanet(aPlant)
        }
        return result
    }
}

func <=(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber <= rNumber
    return result
}

func >=(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber >= rNumber
    return result
}

func >(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber > rNumber

    return result
}

func <(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber < rNumber

    return result
}

func ==(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber == rNumber
   
    return result
}
