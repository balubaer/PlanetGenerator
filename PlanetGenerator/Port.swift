//
//  Port.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Port {
    var planets:Array <Planet>
    var connectionsCount:Int
    var planet:Planet?
    
    init() {
        planets = Array()
        connectionsCount = 0
      //  planet = nil
    }
    
    var description: String {
        var desc = " Port: ";
        
        if planet != nil {
            desc = desc + "MainPlanet <\(planet!.number)>\n"
        }
        
        for item in planets {
            var number = item.number
            desc = desc + " ToPlanet <\(number)>"
        }

        return desc
    }

    func isPlanetOK(aPlanet:Planet, aPlanetsArray:Array <Planet>) -> Bool {
        var result = true
        var planetNumber = planet!.number
        
        if planetNumber != aPlanet.number {
            if contains(planets, aPlanet) {
                result = false
            }
        }
        
        return result
    }
    
    func generatePlanetConnection(aPlanetsArray:Array <Planet>, mainPlanet:Planet) {
        var planetDice = Dice(sides: aPlanetsArray.count)
        var indexNumber = planetDice.roll()
        var realIndex = indexNumber - 1

        self.generateConnectionsCount()
        planet = mainPlanet
        mainPlanet.ports = self
        
        for index in 1...connectionsCount {
            var found = self.isPlanetOK(aPlanetsArray[realIndex], aPlanetsArray: aPlanetsArray)
            
            while (!found) {
                indexNumber = planetDice.roll()
                realIndex = indexNumber - 1

                found = self.isPlanetOK(aPlanetsArray[realIndex], aPlanetsArray: aPlanetsArray)
            }
            if found {
                planets.append(aPlanetsArray[realIndex])
            }
        }
        return
    }
    
    func isConnectionCountOK(aCount:Int) -> Bool {
        var result = false
        
        if (aCount > 1 && aCount <= 5) {
            result = true
        }
        return result
    }

    func generateConnectionsCount() {
        var connectionsCountDice = Dice(sides: 5)
        
        var aCount = connectionsCountDice.roll()
        var found = self.isConnectionCountOK(aCount)
        
        while (!found) {
            aCount = connectionsCountDice.roll()
            found = self.isConnectionCountOK(aCount)
        }
        if found {
            connectionsCount = aCount
        }
    }
}
