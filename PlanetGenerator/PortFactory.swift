//
//  PortFactory.swift
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

class PortFactory {
    var usedPlanetNumbers:Array <Int> = Array()
    var port: Port?
    var planetsCount: Int
    
    init() {
        planetsCount = 0
    }
    
    func addPlanetNumber(aPlanetNumber: Int) {
        if contains(usedPlanetNumbers, aPlanetNumber) == false {
            usedPlanetNumbers.append(aPlanetNumber)
        }
    }
    
    func isPlanetOK(aPlanet:Planet) -> Bool {
        var result = false

        if (port != nil) {
            var portPlanetNumber = port!.planet!.number
            var planetNumber = aPlanet.number
            
            if contains(usedPlanetNumbers, planetNumber) == false {
                result = true
            }
        }
        return result
    }
    
    func isAllConnectionCreated() -> Bool {
        var result = false
        if (port != nil) {
            if planetsCount > usedPlanetNumbers.count {
                result = port!.planets.count == port!.connectionsCount
            } else {
                result = true
            }
        }
        return result
    }

    func generatePlanetConnection(aPlanetsArray:Array <Planet>) {
        if (port != nil) {
            var planetDice = Dice(sides: aPlanetsArray.count)
            
            self.generateConnectionsCount()
            
            while (!isAllConnectionCreated()) {
                var indexNumber = planetDice.roll()
                var realIndex = indexNumber - 1

                var found = self.isPlanetOK(aPlanetsArray[realIndex])
                
                while (!found) {
                    indexNumber = planetDice.roll()
                    realIndex = indexNumber - 1
                    
                    found = self.isPlanetOK(aPlanetsArray[realIndex])
                }
                if found {
                    port!.planets.append(aPlanetsArray[realIndex])
                    self.addPlanetNumber(aPlanetsArray[realIndex].number);
                }
            }
        }
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
            if (port != nil) {
                port!.connectionsCount = aCount
            }
        }
    }

    func connectExistConnection(aPlanet: Planet) {
        
        for planet in planets {
            var aPort = planet.ports
            if (aPort != nil) {
                var portPlanets = aPort!.planets
                if contains(portPlanets, aPlanet) {
                    port?.planets.append(planet)
                }
                self.addPlanetNumber(planet.number)
            }
        }
    }
    
    func createWithPlanetArray(planetArray:Array <Planet>) {
        
        planetsCount = planetArray.count
        
        for planet in planets {
            
            usedPlanetNumbers.removeAll()
            port = Port()
            port!.planet = planet
            port!.planet!.ports = port!
            
            self.addPlanetNumber(planet.number)
            
            self.connectExistConnection(planet)
            self.generatePlanetConnection(planets)
        }
    }
}
