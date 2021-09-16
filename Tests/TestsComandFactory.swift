//
//  Tests.swift
//  Tests
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestsCommandFactory: XCTestCase {
    var commandsString: String?
    var planetArray: Array<Planet>?
    var allPlayerDict: [String: Player]?
    
    func getBundle() -> Bundle? {
        var result: Bundle? = nil
        let array: Array = Bundle.allBundles
        
        for aBundle in array {
            if aBundle.bundleIdentifier == "de.berndniklas.Tests" {
                result = aBundle
            }
            if result != nil {
                break
            }
            
        }
        return result;
    }
    
    override func setUp() {
        super.setUp()
        
        let aBundle: Bundle? = self.getBundle()
        if aBundle != nil {
            if let path = aBundle!.resourcePath {
                var urlPath = NSURL(fileURLWithPath: path)
                urlPath = urlPath.appendingPathComponent("commands.txt") as! NSURL
                
                if let txtPath = urlPath.path {
                    commandsString = try? NSString(contentsOfFile: txtPath , encoding: String.Encoding.utf8.rawValue) as String
                }
            }
            
            if let path = aBundle!.resourcePath {
                var urlPath = NSURL(fileURLWithPath: path)
                urlPath = urlPath.appendingPathComponent("planets.plist") as! NSURL
                let persManager = PersistenceManager()
                
                if let plistPath = urlPath.path {
                    planetArray = persManager.readPlanetPListWithPath(plistPath)
                    allPlayerDict = persManager.allPlayerDict
                }
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFactory() {
        if planetArray != nil && allPlayerDict != nil {
            let commandFactory = CommandFactory(aPlanetArray: planetArray!, aAllPlayerDict: allPlayerDict!)
            if commandsString != nil {
                
                //Test Flotte 1
                var fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 1)
                if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                    XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 0,"### Flotte 1 Anzahl Schiffe falsch ###")
                    XCTAssertTrue(fleetAndHomePlanet.homePlanet!.metal == 1,"### Planet 1 Anzahl Metalle falsch ###")
                } else {
                    XCTFail("### Flotte 1 nicht gefunden  ###")
                }
                
                //Test Flotte 2 Und Planet auf Metalle
                fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 2)
                if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                    XCTAssertTrue(fleetAndHomePlanet.fleet!.cargo == 10,"### Flotte 2 Anzahl Cargo falsch ###")
                    XCTAssertTrue(fleetAndHomePlanet.homePlanet!.metal == 0,"### Planet 2 Anzahl Metalle falsch ###")
                } else {
                    XCTFail("### Flotte 2 nicht gefunden  ###")
                }

                //Test Flotte 3 Und Planet auf Metalle
                fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 3)
                if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                    XCTAssertTrue(fleetAndHomePlanet.fleet!.cargo == 5,"### Flotte 3 Anzahl Cargo falsch ###")
                    XCTAssertTrue(fleetAndHomePlanet.homePlanet!.metal == 0,"### Planet 3 Anzahl Metalle falsch ###")
                } else {
                    XCTFail("### Flotte 3 nicht gefunden  ###")
                }
                
                //Test Flotte 4 Und Planet auf Metalle
                fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 4)
                if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                    XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 7,"### Flotte 4 Anzahl Schiffe falsch ###")
                    XCTAssertTrue(fleetAndHomePlanet.fleet!.cargo == 7,"### Flotte 4 Anzahl Cargo falsch ###")
                    XCTAssertTrue(fleetAndHomePlanet.homePlanet!.metal == 0,"### Planet 4 Anzahl Metalle falsch ###")
                } else {
                    XCTFail("### Flotte 4 nicht gefunden  ###")
                }

                //Test Flotte 5 Und Planet auf Schiffe
                fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 5)
                if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                    XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 0,"### Flotte 5 Anzahl Schiffe falsch ###")
                } else {
                    XCTFail("### Flotte 5 nicht gefunden  ###")
                }

                commandFactory.setCommandStringsWithLongString(playerName: "ZAPHOD", commandString:commandsString!)
                commandFactory.coreGame = true

                commandFactory.executeCommands()
                
                let finalPhase = FinalPhaseCoreGame(aPlanetArray: planetArray!, aAllPlayerDict: allPlayerDict!)
                
                finalPhase.doFinal()

                for planet in planetArray! {
                    if planet.number == 1 {
                        let twoFleetsThere = (planet.fleets.count == 2)
                        XCTAssertTrue(twoFleetsThere, "### Planet 1 hat nicht die 2 Flotten ###")
                        XCTAssertTrue(planet.metal == 0,"### Planet 1 Anzahl Metalle falsch ###")
                        
                        //Test Flotte 2
                        var fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 2)
                        
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertEqual(fleetAndHomePlanet.homePlanet!.number, planet.number, "### Flotte ist beim falschen Planeten ###")
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.number, 2, "### Flotte wurde nicht gefunden ###")
                            
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.cargo, 0, "### Flotte 2 Anzahl Cargo falsch ###")

                        } else {
                            XCTFail("### Flotte 2 nicht gefunden  ###")
                        }
                        
                        //Test Flotte 3
                        fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 3)
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertEqual(fleetAndHomePlanet.homePlanet!.number, planet.number, "### Flotte ist beim falschen Planeten ###")
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.number, 3, "### Flotte wurde nicht gefunden ###")
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.cargo, 3, "### Flotte 3 Anzahl Cargo falsch ###")
                            
                        } else {
                            XCTFail("### Flotte 3 nicht gefunden  ###")
                        }
                        
                    } else if planet.number == 2 {
                        let oneFleetsThere = (planet.fleets.count == 1)
                        XCTAssertTrue(oneFleetsThere, "### Planet 2 hat nicht die 1 Flotte ###")
                        
                        XCTAssertEqual(planet.metal, 10, "### Planet 2 Anzahl Metalle falsch ###")

                        //Test Flotte 1
                        let fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 1)
                        
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertEqual(fleetAndHomePlanet.homePlanet!.number, planet.number, "### Flotte ist beim falschen Planeten ###")
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.number, 1, "### Flotte wurde nicht gefunden ###")
                            XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 1,"### Flotte 1 Anzahl Schiffe falsch ###")
                            
                        } else {
                            XCTFail("### Flotte 1 nicht gefunden  ###")
                        }
                    } else if planet.number == 3 {
                        let noFleetsThere = (planet.fleets.count == 0)
                        XCTAssertTrue(noFleetsThere, "### Planet 3 hat nicht die 0 Flotten ###")
                        XCTAssertEqual(planet.metal, 2, "### Planet 3 Anzahl Metalle falsch ###")

                    } else if planet.number == 4 {
                        
                        XCTAssertEqual(planet.metal, 7, "### Planet 4 Anzahl Metalle falsch ###")

                        var fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 4)
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.cargo, 0, "### Flotte 4 Anzahl Cargo falsch ###")
                            XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 5,"### Flotte 4 Anzahl Schiffe falsch ###")
                        } else {
                            XCTFail("### Flotte 4 nicht gefunden  ###")
                        }
                        
                        fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, number: 5)
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 2,"### Flotte 5 Anzahl Schiffe falsch ###")
                        } else {
                            XCTFail("### Flotte 5 nicht gefunden  ###")
                        }
                    }
                }
                
            } else {
                XCTFail("### TestsCommandFactory.testFactory commandsString is nil ###")
            }
        } else {
            XCTFail("### TestsCommandFactory.testFactory planetArray and allPlayerDict are nil ###")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
