//
//  main.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 08.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

var planets:Array <Planet> = Array()

//Create Planets
for index in 1...10 {
    var planet: Planet = Planet()
    
    planet.number = index
    
    planet.name = "Erde \(index)"
    
    planets.append(planet)
}

//Create Ports with PortFactory

var portFactory = PortFactory()

portFactory.createWithPlanetArray(planets)


//output Result
for item in planets {
    var number = item.number
    println(item.description)
    
}


