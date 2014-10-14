//
//  Command.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

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

class MoveCommand: Command {
    var fleet: Fleet
    var planets: Array <Planet>
    var count = 0
    
    init(aFleet: Fleet, aPlanetArray: Array <Planet>, aString: String, aPlayer: Player) {
        fleet = aFleet
        planets = aPlanetArray
        super.init(aString: aString, aPlayer: aPlayer)
    }
}