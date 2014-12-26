//
//  Command.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

@objc protocol ExecuteCommand {
    func executeCommand()
}

enum TurnPhase: Int {
    case Initial = 1, Unloading, Transfer, Building, Loading, Combat, Movement, Final
}



class Command: Comparable  {
    var string: String
    var player: Player
    var errors: Array <(Int, String)> = Array()
    let turnPhase:TurnPhase
    
    init(aString: String, aPlayer: Player, aTurnPhase: TurnPhase) {
        string = aString
        player = aPlayer
        turnPhase = aTurnPhase
    }
}

func <=(lhs: Command, rhs: Command) -> Bool {
    var lTurnPhase = lhs.turnPhase
    var rTurnPhase = rhs.turnPhase
    
    var result = lTurnPhase.rawValue <= rTurnPhase.rawValue
    return result
}

func >=(lhs: Command, rhs: Command) -> Bool {
    var lTurnPhase = lhs.turnPhase
    var rTurnPhase = rhs.turnPhase
    var result = lTurnPhase.rawValue >= rTurnPhase.rawValue
    return result
}

func >(lhs: Command, rhs: Command) -> Bool {
    var lTurnPhase = lhs.turnPhase
    var rTurnPhase = rhs.turnPhase
    var result = lTurnPhase.rawValue > rTurnPhase.rawValue
    
    return result
}

func <(lhs: Command, rhs: Command) -> Bool {
    var lTurnPhase = lhs.turnPhase
    var rTurnPhase = rhs.turnPhase
    var result = lTurnPhase.rawValue < rTurnPhase.rawValue
    
    return result
}

func ==(lhs: Command, rhs: Command) -> Bool {
    var lTurnPhase = lhs.turnPhase
    var rTurnPhase = rhs.turnPhase
    var result = lTurnPhase == rTurnPhase
    
    return result
}

//FnnnWmmm FnnnWmmmWooo FnnnWmmmWoooWrrr
class MoveCommand: Command, ExecuteCommand{
    var fleet: Fleet
    var planets: Array <Planet>
    var homePlanet: Planet
    var count = 0
    
    init(aFleet: Fleet, aHomePlanet: Planet, aPlanetArray: Array <Planet>, aString: String, aPlayer: Player) {
        fleet = aFleet
        homePlanet = aHomePlanet
        planets = aPlanetArray

        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Movement)
    }
    
    func executeCommand() {
        var fromPlanet: Planet = homePlanet
        var toPlanet: Planet
        var isError = false
        for planet in planets {
            toPlanet = planet
            if fromPlanet.hasConnectionToPlanet(toPlanet) {
                fromPlanet = planet
                //Ambush
            } else {
                //TODO: Fehler
                isError = true
                break
            }
            
            if fleet.ships == 0 {
                isError = true
            }
            
            if fleet.player == nil {
                isError = true
            }
            
            if isError == false {
                if fleet.fired {
                    isError = true
                }
            }
        }
        
        if isError == false {
            fromPlanet = homePlanet
            
            for planet in planets {
                toPlanet = planet
                var fleetMovement = FleetMovement()
                var fleetCopy = Fleet()
                fleetCopy.player = fleet.player
                fleetCopy.number = fleet.number
                fleetMovement.fleet = fleetCopy
                fleetMovement.toPlanet = toPlanet
                fleetMovement.fromPlanet = fromPlanet
                
                fleet.fleetMovements.append(fleetMovement)
                
                fromPlanet = toPlanet
            }
        }
    }
}

//WnnnBqqqFmmm
class BuildFleetShip: Command, ExecuteCommand {
    var fleet: Fleet
    var homePlanet: Planet
    var planetNumber: Int
    var shipsToBuild: Int

    init(aFleet: Fleet, aHomePlanet: Planet, aPlanetNumber: Int,  aShipsToBuild: Int, aString: String, aPlayer: Player) {
        fleet = aFleet
        homePlanet = aHomePlanet
        planetNumber = aPlanetNumber
        shipsToBuild = aShipsToBuild

        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Building)
    }

    func executeCommand() {
        var isError = false

        if homePlanet.number != planetNumber {
            //TODO: Fehler Plante wo die Flotte ist ist nich der gleiche auf dem gebaut werden muss 
            isError = true
        }
        
        if isError == false {
            if contains(homePlanet.fleets, fleet) == false  {
                errors.append(FleetNotOnPlanet_Error)
                isError = true
            }
        }
        
        if isError == false {
            if homePlanet.metal < shipsToBuild {
                //TODO: Fehler zuwenig Metalle
            }
        }
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            fleet.ships += shipsToBuild
            homePlanet.metal -= shipsToBuild
        }
    }
}

//FnnnUqqq FnnnU
class UnloadingMetal: Command, ExecuteCommand {
    var fleet: Fleet
    var homePlanet: Planet
    var metalToUnload: Int

    init(aFleet: Fleet, aHomePlanet: Planet,  aMetalToUnload: Int, aString: String, aPlayer: Player) {
        fleet = aFleet
        homePlanet = aHomePlanet
        metalToUnload = aMetalToUnload
        
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Unloading)
    }
    
    func executeCommand() {
        var isError = false
        
        if isError == false {
            if contains(homePlanet.fleets, fleet) == false  {
                errors.append(FleetNotOnPlanet_Error)
                isError = true
            }
        }
        
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            //Mit metalToUnload == 0 alle Metalle ausladen
            if metalToUnload == 0 || fleet.cargo < metalToUnload {
                homePlanet.metal += fleet.cargo
                fleet.cargo = 0
            } else {
                fleet.cargo -= metalToUnload
                homePlanet.metal += metalToUnload
            }
        }
    }
}

//FnnnTqqqFmmm
class TransferShipsFleetToFleet: Command, ExecuteCommand {
    var fromFleet: Fleet
    var toFleet: Fleet
    var fromHomePlanet: Planet
    var toHomePlanet: Planet
    var shipsToTransfer: Int
    
    init(aFromFleet: Fleet, aToFleet: Fleet, aFromHomePlanet: Planet, aToHomePlanet: Planet, aShipsToTransfer: Int, aString: String, aPlayer: Player) {
        fromFleet = aFromFleet
        toFleet = aToFleet
        fromHomePlanet = aFromHomePlanet
        toHomePlanet = aToHomePlanet
        shipsToTransfer = aShipsToTransfer
        
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Transfer)
    }
    
    func executeCommand() {
        var isError = false
        
        if isError == false {
            if fromHomePlanet != toHomePlanet  {
                //TODO: Fehler art zufügen
                isError = true
            }
            if isError == false {
                if fromFleet.ships < shipsToTransfer {
                    //TODO: Fehler art zufügen
                    isError = true
                }
            }
            //TODO: Check Owner Man kann einer Neutralen Flotte keine Schiffe Transverieren
        }
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            fromFleet.ships -= shipsToTransfer
            toFleet.ships += shipsToTransfer
        }
    }
}

//FaaTxxD
class TransferShipsFleetToDShips: Command, ExecuteCommand {
    var fromFleet: Fleet
    var fromHomePlanet: Planet
    var shipsToTransfer: Int
    
    init(aFromFleet: Fleet, aFromHomePlanet: Planet, aShipsToTransfer: Int, aString: String, aPlayer: Player) {
        fromFleet = aFromFleet
        fromHomePlanet = aFromHomePlanet
        shipsToTransfer = aShipsToTransfer
        
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Transfer)
    }
    
    func executeCommand() {
        var isError = false
        
        if isError == false {
            if isError == false {
                if fromFleet.ships < shipsToTransfer {
                    //TODO: Fehler art zufügen
                    isError = true
                }
            }
        }
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            fromFleet.ships -= shipsToTransfer
            fromHomePlanet.dShips += shipsToTransfer
        }
    }
}

//DaaTxxFbb
class TransferDShipsToFleet: Command, ExecuteCommand {
    var toFleet: Fleet
    var fromHomePlanet: Planet
    var toHomePlanet: Planet
    var shipsToTransfer: Int
    
    init(aToFleet: Fleet, aFromHomePlanet: Planet, aToHomePlanet: Planet, aShipsToTransfer: Int, aString: String, aPlayer: Player) {
        toFleet = aToFleet
        fromHomePlanet = aFromHomePlanet
        toHomePlanet = aToHomePlanet
        shipsToTransfer = aShipsToTransfer
        
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Transfer)
    }
    
    func executeCommand() {
        var isError = false
        
        if isError == false {
            if fromHomePlanet != toHomePlanet  {
                //TODO: Fehler art zufügen
                isError = true
            }
            if isError == false {
                if fromHomePlanet.dShips < shipsToTransfer {
                    //TODO: Fehler art zufügen
                    isError = true
                }
            }
            //TODO: Check Owner Man kann einer Neutralen Flotte keine Schiffe Transverieren
        }
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            fromHomePlanet.dShips -= shipsToTransfer
            toFleet.ships += shipsToTransfer
        }
    }
}

class BuildDShips: Command, ExecuteCommand {
    var planets: Array <Planet>
    let maxBuild = 4
   
    init(aPlanetArray: Array <Planet>, aPlayer: Player) {
        planets = aPlanetArray
        
        super.init(aString: "", aPlayer: aPlayer, aTurnPhase: TurnPhase.Building)
    }
    
    func testPlayerInNextLevelPlanets(nextLevelPlanets: Array <Planet>) -> Bool {
        var result = true
        
        if nextLevelPlanets.count > 0 {
            for planet in nextLevelPlanets {
                if planet.player != nil {
                    if self.player != planet.player! {
                        result = false
                        break
                    }
                } else {
                    result = false
                    break
                }
            }
        } else {
            result = false
        }
        return result
    }
    
    func calculateNumberOfShipsToBuild(planet: Planet) -> Int {
        var result = 0
        var foundDistanceLevel = false
        var disLevel = DistanceLevel(aStartPlanet: planet, aDistanceLevel: 1)
        
        while foundDistanceLevel != true {
            if self.testPlayerInNextLevelPlanets(disLevel.nextLevelPlanets) == false {
                foundDistanceLevel = true
            } else {
                if maxBuild <= disLevel.distanceLevel {
                    foundDistanceLevel = true
                } else {
                    disLevel.goNextLevel()
                }
            }
        }
        
        result = disLevel.distanceLevel

        if result < 1 {
            result = 1
        }
        return result
    }
    
    func executeCommand() {
        for planet in planets {
            if planet.player == self.player {
                var shipsToBuild = calculateNumberOfShipsToBuild(planet)
                
                planet.dShips += shipsToBuild
            }
        }
    }
}

//FaaAFbb
class FireFleetToFleet: Command, ExecuteCommand {
    var fromFleet: Fleet
    var toFleet: Fleet
    var fromHomePlanet: Planet
    var toHomePlanet: Planet

    init(aFromFleet: Fleet, aToFleet: Fleet, aFromHomePlanet: Planet, aToHomePlanet: Planet, aString: String, aPlayer: Player) {
        fromFleet = aFromFleet
        toFleet = aToFleet
        fromHomePlanet = aFromHomePlanet
        toHomePlanet = aToHomePlanet
        
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Transfer)
    }

    func executeCommand() {
        var isError = false
        
        if isError == false {
            if fromHomePlanet != toHomePlanet  {
                //TODO: Fehler art zufügen
                isError = true
            }
        }
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            toFleet.hitedShots += fromFleet.ships
            fromFleet.fired = true
            fromFleet.firesTo = toFleet.name
        }
    }
}

//DaaAFbb
class FireDShipsToFleet: Command, ExecuteCommand {
    var toFleet: Fleet
    var fromHomePlanet: Planet
    var toHomePlanet: Planet
    
    init(aToFleet: Fleet, aFromHomePlanet: Planet, aToHomePlanet: Planet, aString: String, aPlayer: Player) {
        toFleet = aToFleet
        fromHomePlanet = aFromHomePlanet
        toHomePlanet = aToHomePlanet
        
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Transfer)
    }
    
    func executeCommand() {
        var isError = false
        
        if isError == false {
            if fromHomePlanet != toHomePlanet  {
                //TODO: Fehler art zufügen
                isError = true
            }
        }
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            toFleet.hitedShots += fromHomePlanet.dShips
            fromHomePlanet.dShipsFired = true
        }
    }
}

//FaaAD
class FireFleetToDShips: Command, ExecuteCommand {
    var fromFleet: Fleet
    var fromHomePlanet: Planet
    
    init(aFromFleet: Fleet, aFromHomePlanet: Planet, aString: String, aPlayer: Player) {
        fromFleet = aFromFleet
        fromHomePlanet = aFromHomePlanet
        
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Transfer)
    }
    
    func executeCommand() {
        var isError = false
        
        if isError == false {
        }
        
        //TODO: Weiter Tests implementieren
        
        if (isError == false) {
            fromHomePlanet.hitedShotsDShips += fromFleet.ships
            fromFleet.fired = true
            fromFleet.firesTo = "D-Schiffe"
        }
    }
}

//Znn
class AmbushOffForPlanet: Command, ExecuteCommand {
    var planet: Planet
    
    init(aPlanet: Planet, aString: String, aPlayer: Player){
        planet = aPlanet
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Initial)
    }
    
    func executeCommand() {
        var planetPlayer = planet.player
        if planetPlayer != nil {
            if planetPlayer! == player {
                planet.ambushOff = true
            } else {
                //TODO: Fehler
            }
        }
    }
}

//Z
class AmbushOffForPlayer: Command, ExecuteCommand {
    var planets: Array <Planet>
    
    init(aPlanetsArray: Array <Planet>, aString: String, aPlayer: Player){
        planets = aPlanetsArray
        super.init(aString: aString, aPlayer: aPlayer, aTurnPhase: TurnPhase.Initial)
    }
    
    func executeCommand() {
        for planet in planets {
            var planetPlayer = planet.player
            if planetPlayer != nil {
                if planetPlayer! == player {
                    planet.ambushOff = true
                }
            }
        }
    }
}

struct CommandError {
    var errorCode = 0
    var errorString = ""
}