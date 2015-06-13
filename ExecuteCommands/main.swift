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
var programmFilePath = arguments[0] as! String
var plistFilePath = programmFilePath.stringByAppendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>

var playPath = dictFormPList!["playPath"] as! String
var playName = dictFormPList!["playName"] as! String
var coreGame = dictFormPList!["coreGame"] as! Bool


var turnNumber = Int(dictFormPList!["turn"] as! NSNumber)
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
        commandFactory.setCommandStringsWithLongString(playerName, commandString: commandsString! as String)
    } else {
        NSLog("Fehler: CommandsString konnte nicht erzeugt werden für Spieler [\(playerName)]!!!")
    }

}

commandFactory.executeCommands()

var finalPhase = FinalPhaseCoreGame(aPlanetArray: planets, aAllPlayerDict: allPlayerDict)

finalPhase.doFinal()

for (playerName, player) in allPlayerDict {
    var xmlRoot = NSXMLElement(name: "report");

    if let attribute = NSXMLNode.attributeWithName("changeSeq", stringValue: "1") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("endCondition", stringValue: "score:None") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("gameId", stringValue: playName) as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("parametersName", stringValue: "Core") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("parametersToken", stringValue: "core") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("rsw", stringValue: "False") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    if let attribute = NSXMLNode.attributeWithName("turnNumber", stringValue: "\(turnNumber + 1)") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    var childElementPlayer = player.getXMLElement()

    if let attribute = NSXMLNode.attributeWithName("lastInvolvedTurn", stringValue: "\(turnNumber + 1)") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("lastPlayedTurn", stringValue: "\(turnNumber)") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("type", stringValue: "Core") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("typeKey", stringValue: "core") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("score", stringValue: "\(player.points)") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    xmlRoot.addChild(childElementPlayer)

    var outPutString = "Infos zu Spieler: \(playerName) Runde: \(turnNumber) \n"
    var outPutStatistic = OutputPlyerStatisticCoreGame(aPlanets: planets, aPlayer: player)
    outPutStatistic.calculateStatistic()
    outPutString += "\(outPutStatistic.description)\n"
    for planet in planets {
        if Player.isPlanetOutPutForPlayer(player, planet: planet) {
            var childElementPlanet = planet.getXMLElementForPlayer(player)
            xmlRoot.addChild(childElementPlanet)

            outPutString += "\(planet.description)\n\n"
        }
    }
    var outPutFilePath = turnPath.stringByAppendingPathComponent("\(playerName).out")
    outPutString.writeToFile(outPutFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    if let xmlReport = NSXMLDocument.documentWithRootElement(xmlRoot) as? NSXMLDocument{
        xmlReport.version = "1.0"
        xmlReport.characterEncoding = "UTF-8"
        var xmlData = xmlReport.XMLDataWithOptions(Int(NSXMLNodePrettyPrint))
        //var xmlData = xmlReport.XMLData
        outPutFilePath = outPutFilePath.stringByDeletingPathExtension
        if let outPutXMLFilePath = outPutFilePath.stringByAppendingPathExtension("xml") {
            xmlData.writeToFile(outPutXMLFilePath, atomically: true)
        }
    }
}

persManager.planetArray = planets
persManager.writePlanetPListWithPlanetArray(planetPlistFilePath)