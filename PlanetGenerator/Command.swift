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
        NSLog("###### MoveCommand.executeCommand ######")
        
    }
}

struct CommandError {
    var errorCode = 0
    var errorString = ""
}