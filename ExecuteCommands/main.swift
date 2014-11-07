//
//  main.swift
//  ExecuteCommands
//
//  Created by Bernd Niklas on 27.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

var processInfo = NSProcessInfo.processInfo()
var arguments = processInfo.arguments
var programmFilePath = arguments[0] as String
var plistFilePath = programmFilePath.stringByAppendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>

var playPath = dictFormPList!["playPath"] as String
var playName = dictFormPList!["playName"] as String
var coreGame = dictFormPList!["coreGame"] as Bool


var turnNumber = Int(dictFormPList!["turn"] as NSNumber)
var turnNumberBefore = turnNumber - 1

var turnPath = playPath.stringByAppendingPathComponent(playName)

var turnBeforePath = turnPath.stringByAppendingPathComponent("Turn\(turnNumberBefore)")
turnPath = turnPath.stringByAppendingPathComponent("Turn\(turnNumber)")

var planetPlistFileBeforePath = turnBeforePath.stringByAppendingPathComponent("Turn\(turnNumberBefore).plist")
var planetPlistFilePath = turnPath.stringByAppendingPathComponent("Turn\(turnNumber).plist")


var fileManager = NSFileManager.defaultManager()

var isDir : ObjCBool = false

if fileManager.fileExistsAtPath(turnPath, isDirectory: &isDir) == false {
    fileManager.createDirectoryAtPath(turnPath, withIntermediateDirectories: true, attributes: nil, error: nil)
}

var persManager = PersistenceManager()

var planets = persManager.readPlanetPListWithPath(planetPlistFileBeforePath)


var allPlayerDict = persManager.allPlayerDict

var commandFactory = CommandFactory(aPlanetArray: planets, aAllPlayerDict: allPlayerDict)

commandFactory.coreGame = coreGame

//Execute Commands Result
for (playerName, player) in allPlayerDict {
    var commandFilePath = turnPath.stringByAppendingPathComponent("\(playerName).txt")
    
    var commandsString = NSString(contentsOfFile:commandFilePath, encoding: NSUTF8StringEncoding, error: nil)
    if commandsString != nil {
        commandFactory.setCommandStringsWithLongString(playerName, commandString: commandsString!)
    } else {
        NSLog("Fehler: CommandsString konnte nicht erzeugt werden für Spieler [\(playerName)]!!!")
    }

}

commandFactory.executeCommands()

var finalPhase = FinalPhaseCoreGame(aPlanetArray: planets, aAllPlayerDict: allPlayerDict)

finalPhase.doFinal()

for (playerName, player) in allPlayerDict {
    var outPutString = "Infos zu Spieler: \(playerName) Runde: \(turnNumber) \n\n"
    for planet in planets {
        if Player.isPlayOnPlanetWithPlayer(player, planet: planet) {
            outPutString += "\(planet.description)\n\n"
        }
    }
    var outPutFilePath = turnPath.stringByAppendingPathComponent("\(playerName).out")
    outPutString.writeToFile(outPutFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
}

persManager.planetArray = planets
persManager.writePlanetPListWithPlanetArray(planetPlistFilePath)