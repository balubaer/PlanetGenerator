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


class Command {
    var string: String
    var player: Player
    var errorCode: Int
    
    init(aString: String, aPlayer: Player) {
        string = aString
        player = aPlayer
        errorCode = 0
    }
}

class MoveCommand: Command, ExecuteCommand{
    var fleet: Fleet
    var planets: Array <Planet>
    var homePlanet: Planet
    var count = 0
    
    init(aFleet: Fleet, aHomePlanet: Planet, aPlanetArray: Array <Planet>, aString: String, aPlayer: Player) {
        fleet = aFleet
        homePlanet = aHomePlanet
        planets = aPlanetArray
        super.init(aString: aString, aPlayer: aPlayer)
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

struct CommandError {
    var errorCode = 0
    var errorString = ""
}