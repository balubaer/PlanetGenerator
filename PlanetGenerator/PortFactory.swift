//
//  PortFactory.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 08.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class PortFactory {
    var planetsWithEnoughConnections: Array <Planet> = Array()
    var workingPlanets: Array <Planet>
    var planetsCount: Int
    var dice: Dice
    var maxCount: Int
    var moreConnectionPlanet : Int
    var lessConectionPlanet : Int
    var abort : Bool
    
    init() {
        planetsCount = 0
        dice = Dice()
        workingPlanets = Array()
        maxCount = 3
        moreConnectionPlanet = 0
        lessConectionPlanet = 0
        abort = false
    }
    
    func hasPlanetMaxConnetion(_ aPlanet: Planet) -> Bool {
        var result = false
        if (aPlanet.port != nil) {
            let connectionCount = Int(aPlanet.port!.planets.count)
            if (connectionCount == maxCount) {
                result = true
            }
        }
        return result
    }
    
    func hasPlanetEnoughConnection(_ aPlanet: Planet) -> Bool {
        var result = false
        if (aPlanet.port != nil) {
            let connectionCount = Int(aPlanet.port!.planets.count)
            if (connectionCount >= 2 && connectionCount <= maxCount) {
                result = true
            }
        }
        return result
    }
    
    func addPlanetWithEnoughConnectionTest(_ aPlanet: Planet) {
        if self.hasPlanetEnoughConnection(aPlanet) {
            if planetsWithEnoughConnections.contains(aPlanet) == false {
                planetsWithEnoughConnections.append(aPlanet)
            }
        }
    }
    
    func removePlanetFromWorkArrayWithMaxConnectionTest(_ aPlanet: Planet) {
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
    
    func isPlanetForNewConnectionOK(_ aPlanet: Planet) -> Bool {
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
    
    func isEndPlanetForNewConnectionOK(_ aEndPlanet: Planet, aStartPlanet: Planet) -> Bool {
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
    
    func getEndPlanetWithDiceAndStartPlanet(_ aStartPlanet: Planet) -> Planet {
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
    
    func generateOneConnection() {
        var startPlanet: Planet?
        var endPlanet: Planet?
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
    
    func generatePlanetConnection() {
        while (!isAllConnectionCreated() && !abort) {
           self.generateOneConnection()
            if workingPlanets.count < 2 {
                abort = true
            }
        }
    }
    
    func isPlanetForClearConnectionOK(_ aPlanet: Planet) -> Bool {
        var result = false
        if let port = aPlanet.port {
            if port.planets.count > 2 {
                var portsOK = true
                for planet in port.planets {
                    if let aPort = planet.port {
                        if aPort.planets.count < 3 {
                            portsOK = false
                            break
                        }
                    } else {
                        portsOK = false
                        break
                    }
                }
                result = portsOK
            }
        }
        return result
    }
    
    func getPlanetforClearConnectionWithDiceAndPlanetArray() -> Planet {
        var result:Planet? = nil
        dice.setSites(workingPlanets.count)
        
        var indexNumber = dice.roll()
        var realIndex = indexNumber - 1
        result = workingPlanets[realIndex];
        
        if result != nil {
            var found = self.isPlanetForClearConnectionOK(result!)
            
           while (!found) {
                indexNumber = dice.roll()
                realIndex = indexNumber - 1
                result = workingPlanets[realIndex];
                
                found = self.isPlanetForClearConnectionOK(result!)
            }
        }
        return result!
    }

    func clearOneConnection() {
        let planet = getPlanetforClearConnectionWithDiceAndPlanetArray()
        
        if let port = planet.port {
            dice.setSites(port.planets.count)
            let indexNumber = dice.roll()

            let realIndex = indexNumber - 1
            let planetFromPort = port.planets[realIndex]
            port.planets.remove(at: realIndex)
            
            if let portFPFP = planetFromPort.port {
                portFPFP.planets.removeObject(planet)
            }
        }
    }
    
    func createWithPlanetArray(_ planetArray:Array <Planet>) {
        
        planetsCount = planetArray.count
        
        //All Planets get Ports
        for planet in planetArray {
            
            workingPlanets.append(planet)

            let port = Port()
            port.planet = planet
            port.planet!.port = port
        }
        self.generatePlanetConnection()
        
        maxCount = 5
        workingPlanets.removeAll()
        for planet in planetArray {
            workingPlanets.append(planet)
        }
        for _ in 1...moreConnectionPlanet {
            self.generateOneConnection()
        }
        
        workingPlanets.removeAll()
        for planet in planetArray {
            workingPlanets.append(planet)
        }
        for _ in 1...lessConectionPlanet {
            self.clearOneConnection()
        }
    }
}
