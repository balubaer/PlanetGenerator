//
//  main.swift
//  ExecuteCommands
//
//  Created by Bernd Niklas on 27.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

var processInfo = ProcessInfo.processInfo
var arguments = processInfo.arguments
var programmFilePath = arguments[0] as NSString
var plistFilePath = programmFilePath.appendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>

var playPath = dictFormPList!["playPath"] as! NSString
var playName = dictFormPList!["playName"] as! String
var coreGame = dictFormPList!["coreGame"] as! Bool


var turnNumber = Int(truncating: dictFormPList!["turn"] as! NSNumber)
var turnNumberBefore = turnNumber - 1

var turnPath = playPath.appendingPathComponent(playName) as NSString

var turnBeforePath = turnPath.appendingPathComponent("Turn\(turnNumberBefore)") as NSString
turnPath = turnPath.appendingPathComponent("Turn\(turnNumber)") as NSString

var planetPlistFileBeforePath = turnBeforePath.appendingPathComponent("Turn\(turnNumberBefore).plist") as NSString
var planetPlistFilePath = turnPath.appendingPathComponent("Turn\(turnNumber).plist")


var fileManager = FileManager.default

var isDir : ObjCBool = false

if fileManager.fileExists(atPath: turnPath as String, isDirectory: &isDir) == false {
    do {
        try fileManager.createDirectory(atPath: turnPath as String, withIntermediateDirectories: true, attributes: nil)
    } catch _ {
    }
}

var persManager = PersistenceManager()

var planets = persManager.readPlanetPListWithPath(planetPlistFileBeforePath as String)


var allPlayerDict = persManager.allPlayerDict

var commandFactory = CommandFactory(aPlanetArray: planets, aAllPlayerDict: allPlayerDict)

commandFactory.coreGame = coreGame

//Execute Commands Result
for (playerName, _) in allPlayerDict {
    let commandFilePath = turnPath.appendingPathComponent("\(playerName).txt")
    
    let commandsString = try? NSString(contentsOfFile:commandFilePath, encoding: String.Encoding.utf8.rawValue)
    if commandsString != nil {
        commandFactory.setCommandStringsWithLongString(playerName: playerName, commandString: commandsString! as String)
    } else {
        NSLog("Fehler: CommandsString konnte nicht erzeugt werden für Spieler [\(playerName)]!!!")
    }

}

commandFactory.executeCommands()

var finalPhase = FinalPhaseCoreGame(aPlanetArray: planets, aAllPlayerDict: allPlayerDict)

finalPhase.doFinal()

for (playerName, player) in allPlayerDict {
    let xmlRoot = XMLElement(name: "report");

    if let attribute = XMLNode.attribute(withName: "changeSeq", stringValue: "1") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "endCondition", stringValue: "score:None") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "gameId", stringValue: playName) as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "parametersName", stringValue: "Core") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "parametersToken", stringValue: "core") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "rsw", stringValue: "False") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    if let attribute = XMLNode.attribute(withName: "turnNumber", stringValue: "\(turnNumber + 1)") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    let childElementPlayer = player.getXMLElement()

    if let attribute = XMLNode.attribute(withName: "lastInvolvedTurn", stringValue: "\(turnNumber + 1)") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "lastPlayedTurn", stringValue: "\(turnNumber)") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "type", stringValue: "Core") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "typeKey", stringValue: "core") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "score", stringValue: "\(player.points)") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    xmlRoot.addChild(childElementPlayer)

    var outPutString = "Infos zu Spieler: \(playerName) Runde: \(turnNumber + 1) \n"
    let outPutStatistic = OutputPlyerStatisticCoreGame(aPlanets: planets, aPlayer: player)
    outPutStatistic.calculateStatistic()
    outPutString += "\(outPutStatistic.description)\n"
    for planet in planets {
        if Player.isPlanetOutPutForPlayer(player, planet: planet) {
            let childElementPlanet = planet.getXMLElementForPlayer(player)
            xmlRoot.addChild(childElementPlanet)

            outPutString += "\(planet.description)\n\n"
        }
    }
    let outPutFilePath = turnPath.appendingPathComponent("\(playerName).out") as NSString
    do {
        try outPutString.write(toFile: outPutFilePath as String, atomically: true, encoding: String.Encoding.utf8)
    } catch _ {
    }
    if let xmlReport = XMLDocument.document(withRootElement: xmlRoot) as? XMLDocument{
        var outPutFilePathXML = outPutFilePath as NSString

        xmlReport.version = "1.0"
        xmlReport.characterEncoding = "UTF-8"
        let xmlData = xmlReport.xmlData(options: .nodePrettyPrint)
        outPutFilePathXML = outPutFilePathXML.deletingPathExtension as NSString
        outPutFilePathXML = outPutFilePathXML.appendingPathExtension("xml")! as NSString
        let xmlFileString = String(outPutFilePathXML)
        let xmlUrl = URL(fileURLWithPath: xmlFileString)
        try xmlData.write(to: xmlUrl)
    }
}

persManager.planetArray = planets
persManager.writePlanetPListWithPlanetArray(planetPlistFilePath)
