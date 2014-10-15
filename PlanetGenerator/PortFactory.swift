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
    var workingPlanets: Array <Planet>
    var planetsCount: Int
    var dice: Dice
    
    init() {
        planetsCount = 0
        dice = Dice()
        workingPlanets = Array()
    }
    
    func hasPlanetMaxConnetion(aPlanet: Planet) -> Bool {
        var result = false
        if (aPlanet.port != nil) {
            var connectionCount = Int(aPlanet.port!.planets.count)
            if (connectionCount == 5) {
                result = true
            }
        }
        return result
    }
    
    func hasPlanetEnoughConnection(aPlanet: Planet) -> Bool {
        var result = false
        if (aPlanet.port != nil) {
            var connectionCount = Int(aPlanet.port!.planets.count)
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
    
    func removePlanetFromWorkArrayWithMaxConnectionTest(aPlanet: Planet) {
        if self.hasPlanetMaxConnetion(aPlanet) {
            workingPlanets = workingPlanets.filter( {$0 != aPlanet})
            
            var logString = "Planet [\(aPlanet.number)] ist fertig."
            NSLog("%@", logString)
            logString = "WorkingPlaneten: Anzahl [\(workingPlanets.count)]"
            NSLog("%@", logString)
            logString = "Planeten mit ausreichend Verfindungen: Anzahl [\(planetsWithEnoughConnections.count)]"
            NSLog("%@", logString)
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

    func getStartPlanetWithDiceAndPlanetArray() -> Planet {
        var result:Planet? = nil
        
        dice.setSites(workingPlanets.count)
        
        var indexNumber = dice.roll()
        var realIndex = indexNumber - 1
        result = workingPlanets[realIndex];
        
        if (result != nil) {
            var found = self.isPlanetForNewConnectionOK(result!);
            
            while (!found) {
                indexNumber = dice.roll()
                realIndex = indexNumber - 1
                result = workingPlanets[realIndex];
                
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
    
    func getEndPlanetWithDiceAndStartPlanet(aStartPlanet: Planet) -> Planet {
        var result:Planet? = nil
        
        dice.setSites(workingPlanets.count)
        
        var indexNumber = dice.roll()
        var realIndex = indexNumber - 1
        result = workingPlanets[realIndex];
        
        if result != nil {
            var found = self.isEndPlanetForNewConnectionOK(result!, aStartPlanet: aStartPlanet);
            
            while (!found) {
                indexNumber = dice.roll()
                realIndex = indexNumber - 1
                result = workingPlanets[realIndex];
                
                found = self.isEndPlanetForNewConnectionOK(result!, aStartPlanet: aStartPlanet)
            }
        }
        
        return result!
        
    }
    
    func generatePlanetConnection() {
        var startPlanet: Planet?
        var endPlanet: Planet?

        while (!isAllConnectionCreated()) {
            startPlanet = self.getStartPlanetWithDiceAndPlanetArray()
            if (startPlanet != nil) {
                endPlanet = self.getEndPlanetWithDiceAndStartPlanet(startPlanet!)
                if (endPlanet != nil) {
                    startPlanet!.port!.planets.append(endPlanet!)
                    endPlanet!.port!.planets.append(startPlanet!)
                    self.addPlanetWithEnoughConnectionTest(startPlanet!)
                    self.addPlanetWithEnoughConnectionTest(endPlanet!)
                    self.removePlanetFromWorkArrayWithMaxConnectionTest(startPlanet!)
                    self.removePlanetFromWorkArrayWithMaxConnectionTest(endPlanet!)
                    
                }
            }
        }
    }
    
    func createWithPlanetArray(planetArray:Array <Planet>) {
        
        planetsCount = planetArray.count
        
        //All Planets get Ports
        for planet in planets {
            
            workingPlanets.append(planet)

            var port = Port()
            port.planet = planet
            port.planet!.port = port
        }
        self.generatePlanetConnection()
    }
}
