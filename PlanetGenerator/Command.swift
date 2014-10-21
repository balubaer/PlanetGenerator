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
    var errorCode: Int
    let turnPhase:TurnPhase
    
    init(aString: String, aPlayer: Player, aTurnPhase: TurnPhase) {
        string = aString
        player = aPlayer
        errorCode = 0
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
            //TODO: Test Ships
        }
        
        if isError == false {
            homePlanet.fleets.removeObject(fleet)
            var counter = 0
            var planetCount = planets.count
            fromPlanet = homePlanet
            
            for planet in planets {
                toPlanet = planet
                var fleetMovement = FleetMovement()
                fleetMovement.fleet = fleet
                fleetMovement.toPlanet = toPlanet
                
                fromPlanet.fleetMovements.append(fleetMovement)
                
                counter++
                if counter == planetCount {
                    planet.fleets.append(fleet)
                }
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
                //TODO: Fehler Flotte ist nicht auf Planet
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

struct CommandError {
    var errorCode = 0
    var errorString = ""
}