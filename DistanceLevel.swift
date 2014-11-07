//
//  DistanceLevel.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.11.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class DistanceLevel {
    var startPlanet: Planet
    var distanceLevel: Int
    var passedPlanets: Array <Planet> = Array()
    var nextLevelPlanets: Array <Planet> = Array()
    var stopCreateNewNextLevelPlanets = false
    
    init(aStartPlanet: Planet, aDistanceLevel: Int) {
        if aDistanceLevel < 1 {
            distanceLevel = 1
        } else {
            distanceLevel = aDistanceLevel
        }
        startPlanet = aStartPlanet
        for levelCount in 1...distanceLevel {
            if levelCount == 1 {
                passedPlanets.append(startPlanet)
                var planets = startPlanet.port?.planets
                if planets != nil {
                    for planet in planets! {
                        nextLevelPlanets.append(planet)
                    }
                }
            } else {
                self.createNewNextLevelPlanets()
                if stopCreateNewNextLevelPlanets {
                    distanceLevel = levelCount - 1
                    break
                }
            }
        }
    }
    
    func createNewNextLevelPlanets() {
        var oldNextLevelPlanets = nextLevelPlanets
        var newPassedPlanets = passedPlanets
        
        for planet in nextLevelPlanets {
            if contains(newPassedPlanets, planet) == false {
                newPassedPlanets.append(planet)
            }
        }
        nextLevelPlanets.removeAll()
        
        for planet in oldNextLevelPlanets {
            var port = planet.port
            
            if port != nil {
                var planetsFromPort = port!.planets
                
                for planetFromPort in planetsFromPort {
                    if contains(newPassedPlanets, planetFromPort) == false {
                        if contains(nextLevelPlanets, planetFromPort) == false {
                            nextLevelPlanets.append(planetFromPort)
                        }
                    }
                }
            }
        }
        if nextLevelPlanets.count == 0 {
            stopCreateNewNextLevelPlanets = true
            nextLevelPlanets = oldNextLevelPlanets
        } else {
            passedPlanets = newPassedPlanets
        }
    }

    func goNextLevel() {
        distanceLevel++
        self.createNewNextLevelPlanets()
    }
}