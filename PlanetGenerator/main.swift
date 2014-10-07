//
//  main.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 08.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

func planetWithNumber(planets:Array<Planet>, number:Int) -> Planet? {
    var result:Planet? = nil
    for planet in planets {
        if planet.number == number {
            result = planet
        }
    }
    
    return result;
}

var planets:Array <Planet> = Array()

//Create Planets
for index in 1...10 {
    var planet: Planet = Planet()
    
    planet.number = index
    
    planet.name = "Erde \(index)"
    
    planets.append(planet)
    
    if contains(planets, planet) {
        println("planet is in planets")
    } else {
        println("planet is in planets")
        
    }
}

//Create Ports with Dice
var dice = Dice(sides: planets.count)
var planetNumbers = [Int]()

for planet in planets {
    var number = planet.number
    
    planetNumbers += [number]
    // planetNumbers.append(number)
}

for index in 1...planets.count {
    var port: Port = Port()
    
    var number = dice.roll()
    var found = contains(planetNumbers, number)
    
    while (!found) {
        number = dice.roll()
        found = contains(planetNumbers, number)
    }
    
    var aPlanet:Planet? = planetWithNumber(planets, number)
    var planetNumbersCount = planetNumbers.count
    port.generatePlanetConnection(planets, mainPlanet: aPlanet!)
    
    for var index = planetNumbersCount; index > 0; index-- {
        
        var realIndex = index - 1
        var numberFromArray = planetNumbers[realIndex]
        
        if (numberFromArray == port.planet?.number) {
            planetNumbers.removeAtIndex(realIndex)
        }
    }
}

for item in planets {
    var number = item.number
    println(item.description)
    
}


