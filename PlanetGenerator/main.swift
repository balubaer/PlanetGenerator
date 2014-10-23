//
//  main.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 08.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

var processInfo = NSProcessInfo.processInfo()
var arguments = processInfo.arguments
var programmFilePath = arguments[0] as String
var plistFilePath = programmFilePath.stringByAppendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>
var planetCount = Int(dictFormPList!["planetCount"] as NSNumber)

var playerNamesFromPlist = Array(dictFormPList!["player"] as NSArray)
var playerNames: Array <String> = Array()

for playerName in playerNamesFromPlist {
    playerNames.append(String(playerName as String))
}

var fleetCount = Int(dictFormPList!["fleetCount"] as NSNumber)

var fleetsOnHomePlanet = Int(dictFormPList!["fleetsOnHomePlanet"] as NSNumber)
var startShipsCount = Int(dictFormPList!["startShipsCount"] as NSNumber)


var planets:Array <Planet> = Array()


//Create Planets
for index in 1...planetCount {
    var planet: Planet = Planet()
    
    planet.number = index
    
    planets.append(planet)
}

//Create Ports with PortFactory

var portFactory = PortFactory()

portFactory.createWithPlanetArray(planets)

var fleetFactory = FleetFactory(aFleetCount: fleetCount)

fleetFactory.createWithPlanetArray(planets)

var playerFactory = PlayerFactory(aPlayerNameArray: playerNames)

playerFactory.createWithPlanetArray(planets, fleetCount: fleetCount, aFleetsOnHomePlanet: fleetsOnHomePlanet, startShipsCount: startShipsCount)

//output Result
for item in planets {
    var number = item.number
    println(item.description)
    
}


