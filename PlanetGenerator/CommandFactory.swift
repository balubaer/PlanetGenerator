//
//  CommandFactory.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class CommandFactory {
    var planets: Array <Planet>
    var commandStringsDict: Dictionary <String, Array <String>>
    var processCommand: String?
    var commandChars: String?
    var commandPlayer: Player?
    var commandElements: Array <String>
    var allPlayerDict: [String: Player]
    var coreGame: Bool = false

    init(aPlanetArray: Array <Planet>, aAllPlayerDict: [String: Player]) {
        planets = aPlanetArray
        allPlayerDict = aAllPlayerDict
        commandStringsDict = Dictionary()
        commandElements = Array()
    }
    
    func setCommandStringsWithLongString(playerName:String, commandString: String) {
        let aSet = NSSet(array: commandString.components(separatedBy: [" ", "\n", "\r"]))
        let array = aSet.allObjects as? Array<String>
        
        if array != nil {
            commandStringsDict[playerName] = array
        }
    }

    //WnnnBqqqFmmm
    
    func findBuildParameterForFleet() -> (fleet: Fleet, homePlanet:Planet, planetNumber: Int, shipsToBuild: Int) {
        var counter = 0
        var planetNumber = 0
        var shipsToBuild = 0
        var fleet: Fleet = Fleet()
        var homePlanet: Planet = Planet()

        for commantElement in commandElements {
            if counter == 0 {
                let aPlanetNumber = Int(extractNumberString(commantElement))
                if aPlanetNumber != nil {
                    planetNumber = aPlanetNumber!
                }
            } else if counter == 1 {
                let aShipsToBuild = Int(extractNumberString(commantElement))
                if aShipsToBuild != nil {
                    shipsToBuild = aShipsToBuild!
                }
            } else {
                let fleetNumber: Int? = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fleet = aFleetAndHomePlanet.fleet!
                        homePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter += 1
        }
        return (fleet, homePlanet, planetNumber, shipsToBuild)
    }
    
    func createBuildFleetShipCommand() -> BuildFleetShip {
        let bulidParameterForFleet = findBuildParameterForFleet()
        return BuildFleetShip(aFleet: bulidParameterForFleet.fleet, aHomePlanet: bulidParameterForFleet.homePlanet, aPlanetNumber: bulidParameterForFleet.planetNumber,  aShipsToBuild: bulidParameterForFleet.shipsToBuild, aString: processCommand!, aPlayer: commandPlayer!)
    }

    //FnnnUqqq FnnnU
    func findParameterForUnloadingMetal() -> (fleet: Fleet, homePlanet:Planet, metalToUnload: Int) {
        var counter = 0
        var metalToUnload = 0
        var fleet: Fleet = Fleet()
        var homePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                let fleetNumber: Int? = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fleet = aFleetAndHomePlanet.fleet!
                        homePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                let aMetalToUnload = Int(extractNumberString(commantElement))
                if aMetalToUnload != nil {
                    metalToUnload = aMetalToUnload!
                }
            }
            counter += 1
        }
        return (fleet, homePlanet, metalToUnload)
    }
    
    func createUnloadingMetalCommand() -> UnloadingMetal {
        let parameterForUnlodingMetal = findParameterForUnloadingMetal()
        return UnloadingMetal(aFleet: parameterForUnlodingMetal.fleet, aHomePlanet: parameterForUnlodingMetal.homePlanet,  aMetalToUnload: parameterForUnlodingMetal.metalToUnload, aString: processCommand!, aPlayer: commandPlayer!)
    
    }
    
    // FnnnWmmm FnnnWmmmWooo FnnnWmmmWoooWrrr
    func findFleetAndPlanets() -> (fleet: Fleet, homePlanet:Planet, planetArray: Array <Planet>) {
        var fleet: Fleet = Fleet()
        var homePlanet: Planet = Planet()
        var planetArray: Array <Planet> = Array()
        var counter = 0
        
        for commantElement in commandElements {
            if counter == 0 {
                let fleetNumber: Int? = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fleet = aFleetAndHomePlanet.fleet!
                        homePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else {
                let planetNumber: Int? = Int(extractNumberString(commantElement))
                if planetNumber != nil {
                    let planet = planetWithNumber(planets, number: planetNumber!)
                    
                    if planet != nil {
                        planetArray.append(planet!)
                    }
                }
            }
            counter += 1
        }
        return (fleet, homePlanet, planetArray)
    }
    
    func createMoveCommand() -> MoveCommand {
        let fleetAndPlanets = findFleetAndPlanets()
        return MoveCommand(aFleet: fleetAndPlanets.fleet, aHomePlanet:fleetAndPlanets.homePlanet, aPlanetArray: fleetAndPlanets.planetArray, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findFromFleetToFleetAndPlanets() -> (fromFleet: Fleet, toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet, shipsToTransfer: Int) {
        var counter = 0
        var shipsToTransfer = 0
        var fromFleet: Fleet = Fleet()
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                let fleetNumber = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                let aShipsToTransfer = Int(extractNumberString(commantElement))
                if aShipsToTransfer != nil {
                    shipsToTransfer = aShipsToTransfer!
                }
            } else {
                let fleetNumber: Int? = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter += 1
        }
        return (fromFleet, toFleet, fromHomePlanet, toHomePlanet, shipsToTransfer)
    }
    
    func createTransferShipsFleetToFleetCommand() -> TransferShipsFleetToFleet {
        let fromFleetToFleetAndPlanets = findFromFleetToFleetAndPlanets()
        return TransferShipsFleetToFleet(aFromFleet: fromFleetToFleetAndPlanets.fromFleet, aToFleet: fromFleetToFleetAndPlanets.toFleet, aFromHomePlanet: fromFleetToFleetAndPlanets.fromHomePlanet, aToHomePlanet: fromFleetToFleetAndPlanets.toHomePlanet, aShipsToTransfer: fromFleetToFleetAndPlanets.shipsToTransfer, aString: processCommand!, aPlayer: commandPlayer!)
    }
    func findFromFleetToDShipsAndPlanet() -> (fromFleet: Fleet, fromHomePlanet:Planet, shipsToTransfer: Int) {
        var counter = 0
        var fromFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var shipsToTransfer = 0

        for commantElement in commandElements {
            if counter == 0 {
                let fleetNumber = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                let aShipsToTransfer = Int(extractNumberString(commantElement))
                if aShipsToTransfer != nil {
                    shipsToTransfer = aShipsToTransfer!
                }
            }
            
            counter += 1
        }
        return (fromFleet, fromHomePlanet, shipsToTransfer)
    }

    func createTransferShipsFleetToDShipsCommand() -> TransferShipsFleetToDShips {
        let fromFleetToDShipsAndPlanet = findFromFleetToDShipsAndPlanet()
        return TransferShipsFleetToDShips(aFromFleet: fromFleetToDShipsAndPlanet.fromFleet, aFromHomePlanet: fromFleetToDShipsAndPlanet.fromHomePlanet, aShipsToTransfer: fromFleetToDShipsAndPlanet.shipsToTransfer, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findTransferDShipsToFleetAndPlanets() -> (toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet, shipsToTransfer: Int) {
        var counter = 0
        var shipsToTransfer = 0
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                let planetNumber = Int(extractNumberString(commantElement))
                if planetNumber != nil {
                    fromHomePlanet = (planetWithNumber(planets, number: planetNumber!) as Planet? ?? nil)!
                }
            } else if counter == 1 {
                let aShipsToTransfer = Int(extractNumberString(commantElement))
                if aShipsToTransfer != nil {
                    shipsToTransfer = aShipsToTransfer!
                }
            } else {
                let fleetNumber: Int? = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter += 1
        }
        return (toFleet, fromHomePlanet, toHomePlanet, shipsToTransfer)
    }

    func createTransferDShipsToFleetCommand() -> TransferDShipsToFleet {
        let transferDShipsToFleetAndPlanets = findTransferDShipsToFleetAndPlanets()
        return TransferDShipsToFleet(aToFleet: transferDShipsToFleetAndPlanets.toFleet, aFromHomePlanet: transferDShipsToFleetAndPlanets.fromHomePlanet, aToHomePlanet: transferDShipsToFleetAndPlanets.toHomePlanet, aShipsToTransfer: transferDShipsToFleetAndPlanets.shipsToTransfer, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findFromFleetFireToFleetAndPlanets() -> (fromFleet: Fleet, toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet) {
        var counter = 0
        var fromFleet: Fleet = Fleet()
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                let fleetNumber = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                //Nichts zu tun
            } else {
                let fleetNumber: Int? = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter += 1
        }
        return (fromFleet, toFleet, fromHomePlanet, toHomePlanet)
    }

    func createFireFleetToFleetCommand() -> FireFleetToFleet {
        let fromFleetFireToFleetAndPlanets = findFromFleetFireToFleetAndPlanets()
        return FireFleetToFleet(aFromFleet: fromFleetFireToFleetAndPlanets.fromFleet, aToFleet: fromFleetFireToFleetAndPlanets.toFleet, aFromHomePlanet: fromFleetFireToFleetAndPlanets.fromHomePlanet, aToHomePlanet: fromFleetFireToFleetAndPlanets.toHomePlanet, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findFromFleetFireToDShipsAndPlanets() -> (fromFleet: Fleet, fromHomePlanet:Planet) {
        var counter = 0
        var fromFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                let fleetNumber = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter += 1
        }
        return (fromFleet, fromHomePlanet)
    }

    func createFireFleetToDShipsCommand() -> FireFleetToDShips {
        let fromFleetFireToDShipsAndPlanets = findFromFleetFireToDShipsAndPlanets()
       return FireFleetToDShips(aFromFleet: fromFleetFireToDShipsAndPlanets.fromFleet, aFromHomePlanet: fromFleetFireToDShipsAndPlanets.fromHomePlanet, aString: processCommand!, aPlayer: commandPlayer!)
    }

    func findFromDShipsFireToFleetAndPlanets() -> (toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet) {
        var counter = 0
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                let planetNumber = Int(extractNumberString(commantElement))
                if planetNumber != nil {
                    fromHomePlanet = (planetWithNumber(planets, number: planetNumber!) as Planet?)!
                }
            } else if counter == 1 {
                //Nichts zu tun
            } else {
                let fleetNumber: Int? = Int(extractNumberString(commantElement))
                if fleetNumber != nil {
                    let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, number: fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter += 1
        }
        return (toFleet, fromHomePlanet, toHomePlanet)
    }

    func createFireDShipsToFleetCommand() -> FireDShipsToFleet {
        let fromDShipsFireToFleetAndPlanets = findFromDShipsFireToFleetAndPlanets()
        return FireDShipsToFleet(aToFleet: fromDShipsFireToFleetAndPlanets.toFleet, aFromHomePlanet: fromDShipsFireToFleetAndPlanets.fromHomePlanet, aToHomePlanet: fromDShipsFireToFleetAndPlanets.toHomePlanet, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    // Znn
    func findPlanet() -> Planet {
        var planet: Planet = Planet()
        var counter = 0
        
        for commantElement in commandElements {
            if counter == 0 {
                let planetNumber: Int? = Int(extractNumberString(commantElement))
                if planetNumber != nil {
                    let planetFromNumber = planetWithNumber(planets, number: planetNumber!)
                    if planetFromNumber != nil {
                        planet = planetFromNumber!
                    }
                }
            }
            counter += 1
        }
        return planet
    }

    
    func createAmbushOffForPlanet() -> AmbushOffForPlanet {
        let planet = findPlanet()
        return AmbushOffForPlanet(aPlanet: planet, aString: processCommand!, aPlayer: commandPlayer!)
    }

    func createAmbushOffForPlayer() -> AmbushOffForPlayer {
        return AmbushOffForPlayer(aPlanetsArray: planets, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func createTeammateForPlayer() -> AddTeammate {
     return AddTeammate(aAllPlayerDict: allPlayerDict, aString: processCommand!, aPlayer: commandPlayer!)
    }

    func createRemoveTeammateForPlayer() -> RemoveTeammate {
        return RemoveTeammate(aAllPlayerDict: allPlayerDict, aString: processCommand!, aPlayer: commandPlayer!)
    }

    func getCommandInstance() -> AnyObject? {
        var result: AnyObject? = nil
        if commandChars != nil {
            let characterArray: Array <Character> = Array((commandChars!))
            
            if characterArray.count >= 2 {
                switch characterArray[0] {
                case "F":
                    switch characterArray[1] {
                    case "W":
                        result = createMoveCommand()
                    case "U":
                        result = createUnloadingMetalCommand()
                    case "T":
                        if characterArray.count == 3 {
                            switch characterArray[2] {
                            case "F":
                                result = createTransferShipsFleetToFleetCommand()
                            case "D":
                                result = createTransferShipsFleetToDShipsCommand()
                            default:
                                result = nil
                            }
                        }
                    case "A":
                        if characterArray.count == 3 {
                            switch characterArray[2] {
                            case "F":
                                result = createFireFleetToFleetCommand()
                            case "D":
                                result = createFireFleetToDShipsCommand()
                            default:
                                result = nil
                                
                            }
                        }
                    default:
                        result = nil
                    }
                case "W":
                    switch characterArray[1] {
                    case "B":
                        if characterArray.count == 3 {
                            if characterArray[2] == "F" {
                                result = createBuildFleetShipCommand()
                            }
                        }
                    default:
                        result = nil
                    }
                case "D":
                    switch characterArray[1] {
                    case "A":
                        if characterArray.count == 3 {
                            if characterArray[2] == "F" {
                                result = createFireDShipsToFleetCommand()
                            }
                        }
                    case "T":
                        if characterArray.count == 3 {
                            if characterArray[2] == "F" {
                                result = createTransferDShipsToFleetCommand()
                            }
                        }
                    default:
                        result = nil
                    }
                case "Z":
                    result = createAmbushOffForPlanet()
                case "A":
                    if characterArray[1] == "=" {
                        result = createTeammateForPlayer();
                    }
                case "N":
                    if characterArray[1] == "=" {
                        result = createRemoveTeammateForPlayer();
                    }
                default:
                    result = nil
                }
            } else if characterArray.count == 1 {
                switch characterArray[0] {
                    case "Z":
                    result = createAmbushOffForPlayer()
                default:
                    result = nil
                }
            }
        }
        return result
    }
    
    func executeCommands() {
        var commandArray:Array <Command> = Array()
        
        for (playerName, commandStrings) in commandStringsDict {
            for command in commandStrings {
                commandChars = ""
                processCommand = command
                commandElements = Array()
                var counter = 0
                let charCount = command.count
                var foundCommandElementEnd = false
                var commandElement = String()
                
                for character in (command as String) {
                    
                    if isCharacterANumber(character) == false {
                        commandChars?.append(character)
                        if counter != 0 {
                            foundCommandElementEnd = true
                        }
                        if foundCommandElementEnd {
                            commandElements.append(commandElement)
                            commandElement = String()
                            foundCommandElementEnd = false
                        }
                        commandElement.append(character)
                    } else {
                        commandElement.append(character)
                    }
                    counter += 1
                    if counter == charCount {
                        commandElements.append(commandElement)
                    }
                }
                commandPlayer = allPlayerDict[playerName]
                let commandInstance:AnyObject? = self.getCommandInstance()
                if commandInstance != nil {
                    if commandInstance is Command {
                        commandArray.append(commandInstance as! Command)
                    }
                }
            }
        }
        
        if coreGame {
            for (_, player) in allPlayerDict {
                let buildDShips = BuildDShips(aPlanetArray: planets, aPlayer: player)
                commandArray.append(buildDShips as Command)
            }
        }
        
        commandArray.sort { $0 < $1 }
        
        for command in commandArray {
            (command as! ExecuteCommand).executeCommand()
        }
    }
}
