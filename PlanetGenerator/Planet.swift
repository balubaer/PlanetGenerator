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
    var name: String {
        var aName = "W\(number)"
        return aName
    }
    var port: Port?
    var player: Player?
    var fleets: Array <Fleet>
    var industry: Int = 0
    var metal: Int = 0
    var mines: Int = 0
    var population: Int = 0
    var limit: Int = 0
    var round: Int = 0
    var iShips: Int = 0
    var pShips: Int = 0
    
    //TODO: niklas Kunstwerke ... V70:Plastik Mondstein
    
    var description: String {
        var desc = self.name
        if port != nil {
            desc = port!.description
        }
        if player != nil {
            desc += " \(player!.description)"
        }
        
        var resouceString = createResourceString()
        
        if countElements(resouceString) != 0 {
            desc += " "
            desc += resouceString
        }
        
        return desc
    }
    
    init() {
        fleets = Array()
    }
    
    func hasConnectionToPlanet(aPlant : Planet) -> Bool {
        var result = false
        if port != nil {
            result = port!.hasConnectionToPlanet(aPlant)
        }
        return result
    }
    
    func createResourceString () -> String {
        var resourceArray:Array <String> = Array()
        var result:String = ""
        
        if industry != 0 {
            resourceArray.append("Industrie=\(industry)")
        }
        if metal != 0 {
            resourceArray.append("Metall=\(metal)")
        }
        if mines != 0 {
            resourceArray.append("Minen=\(mines)")
        }
        if population != 0 {
            resourceArray.append("Bevoelkerung=\(population)")
        }
        if limit != 0 {
            resourceArray.append("Limit=\(limit)")
        }
        if round != 0 {
            resourceArray.append("Runden=\(round)")
        }
        if iShips != 0 {
            resourceArray.append("I-Schiffe=\(iShips)")
        }
        if pShips != 0 {
            resourceArray.append("P-Schiffe=\(pShips)")
        }
        
        if resourceArray.count != 0 {
            
            result = createBracketAndCommarStringWithStringArray(resourceArray)
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
