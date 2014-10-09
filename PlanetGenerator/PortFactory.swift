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
    var planetsWithEnoughConnections: Array <Planet> = Array()
    var planetsCount: Int
    var dice: Dice
    init() {
        planetsCount = 0
        dice = Dice()
    }
    
    func hasPlanetMaxConnetion(aPlanet: Planet) -> Bool {
        var result = false
        if (aPlanet.ports != nil) {
            var connectionCount = Int(aPlanet.ports!.planets.count)
            if (connectionCount == 5) {
                result = true
            }
        }
        return result
    }
    
    func hasPlanetEnoughConnection(aPlanet: Planet) -> Bool {
        var result = false
        if (aPlanet.ports != nil) {
            var connectionCount = Int(aPlanet.ports!.planets.count)
            if (connectionCount >= 2 && connectionCount <= 5) {
                result = true
            }
        }
        return result
    }
    
    func addPlanetWithEnoughConnectionTest(aPlanet: Planet) {
        if self.hasPlanetEnoughConnection(aPlanet) {
            if contains(planetsWithEnoughConnections, aPlanet) == false {
                planetsWithEnoughConnections.append(aPlanet)
            }
        }
    }
    
    func isAllConnectionCreated() -> Bool {
        var result = false
            if planetsCount == planetsWithEnoughConnections.count {
                result = true
            }
        return result
    }
    
    func isPlanetForNewConnectionOK(aPlanet: Planet) -> Bool {
        var result = false
        
        if (self.hasPlanetMaxConnetion(aPlanet) == false) {
            result = true
        }
        return result
    }

    func getStartPlanetWithDiceAndPlanetArray(aPlanetsArray:Array <Planet>) -> Planet {
        var result:Planet? = nil
        
        dice.setSites(planetsCount)
        
        var indexNumber = dice.roll()
        var realIndex = indexNumber - 1
        result = aPlanetsArray[realIndex];
        
        if (result != nil) {
            var found = self.isPlanetForNewConnectionOK(result!);
            
            while (!found) {
                indexNumber = dice.roll()
                realIndex = indexNumber - 1
                result = aPlanetsArray[realIndex];
                
                found = self.isPlanetForNewConnectionOK(result!)
            }
        }
        
        return result!
        
    }
    
    func isEndPlanetForNewConnectionOK(aEndPlanet: Planet, aStartPlanet: Planet) -> Bool {
        var result = false
        
        if (aEndPlanet.number != aStartPlanet.number) {
            if (self.hasPlanetMaxConnetion(aEndPlanet) == false) {
                if aEndPlanet.hasConnectionToPlanet(aStartPlanet) == false {
                    result = true
                }
            }
        }
        return result
    }
    
    func getEndPlanetWithDicePlanetArrayAndStartPlanet(aPlanetsArray:Array <Planet>, aStartPlanet: Planet) -> Planet {
        var result:Planet? = nil
        
        dice.setSites(planetsCount)
        
        var indexNumber = dice.roll()
        var realIndex = indexNumber - 1
        result = aPlanetsArray[realIndex];
        
        if result != nil {
            var found = self.isEndPlanetForNewConnectionOK(result!, aStartPlanet: aStartPlanet);
            
            while (!found) {
                indexNumber = dice.roll()
                realIndex = indexNumber - 1
                result = aPlanetsArray[realIndex];
                
                found = self.isEndPlanetForNewConnectionOK(result!, aStartPlanet: aStartPlanet)
            }
        }
        
        return result!
        
    }
    
    func generatePlanetConnection(aPlanetsArray:Array <Planet>) {
        var startPlanet: Planet?
        var endPlanet: Planet?

        while (!isAllConnectionCreated()) {
            startPlanet = self.getStartPlanetWithDiceAndPlanetArray(aPlanetsArray)
            if (startPlanet != nil) {
                endPlanet = self.getEndPlanetWithDicePlanetArrayAndStartPlanet(aPlanetsArray, aStartPlanet: startPlanet!)
                if (endPlanet != nil) {
                    startPlanet!.ports!.planets.append(endPlanet!)
                    endPlanet!.ports!.planets.append(startPlanet!)
                    self.addPlanetWithEnoughConnectionTest(startPlanet!)
                    self.addPlanetWithEnoughConnectionTest(endPlanet!)
                }
            }
        }
    }
    
    func createWithPlanetArray(planetArray:Array <Planet>) {
        
        planetsCount = planetArray.count
        
        //All Planets get Ports
        for planet in planets {
            var port = Port()
            port.planet = planet
            port.planet!.ports = port
        }
        self.generatePlanetConnection(planets)
    }
}
