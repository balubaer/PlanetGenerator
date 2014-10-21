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
    
    func getBundle() -> NSBundle? {
        var result: NSBundle? = nil
        var array: Array = NSBundle.allBundles()
        
        for aBundle in array {
            if aBundle.bundleIdentifier == "de.berndniklas.Tests" {
                result = aBundle as? NSBundle
            }
            if result != nil {
                break
            }
            
        }
        return result;
    }
    
    override func setUp() {
        super.setUp()
        
        var aBundle: NSBundle? = self.getBundle()
        if aBundle != nil {
            var path: NSString? = aBundle!.resourcePath
            path = path?.stringByAppendingPathComponent("commands.txt")
            
            if path != nil {
                commandsString = NSString(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: nil)
            }
            path = aBundle!.resourcePath
            path = path?.stringByAppendingPathComponent("planets.plist")
            if path != nil {
                var persManager = PersistenceManager()

                planetArray = persManager.readPlanetPListWithPath(path!)
            }

        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFactory() {
        if planetArray != nil {
            var commandFactory = CommandFactory(aPlanetArray: planetArray!)
            if commandsString != nil {
                
                //Test Flotte 1
                var fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, 1)
                if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                    XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 0,"### Flotte 1 Anzahl Schiffe falsch ###")
                    XCTAssertTrue(fleetAndHomePlanet.homePlanet!.metal == 1,"### Planet 1 Anzahl Metalle falsch ###")
                } else {
                    XCTFail("### Flotte 1 nicht gefunden  ###")
                }
                
                commandFactory.setCommandStringsWithLongString(commandsString!)
                commandFactory.executeCommands()
                
                for planet in planetArray! {
                    if planet.number == 1 {
                        var twoFleetsThere = (planet.fleets.count == 2)
                        XCTAssertTrue(twoFleetsThere, "### Planet 1 hat nicht die 2 Flotten ###")
                        XCTAssertTrue(planet.metal == 0,"### Planet 1 Anzahl Metalle falsch ###")
                        
                        //Test Flotte 2
                        var fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, 2)
                        
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertEqual(fleetAndHomePlanet.homePlanet!.number, planet.number, "### Flotte ist beim falschen Planeten ###")
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.number, 2, "### Flotte wurde nicht gefunden ###")
                        } else {
                            XCTFail("### Flotte 2 nicht gefunden  ###")
                        }
                        
                        //Test Flotte 3
                        fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, 3)
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertEqual(fleetAndHomePlanet.homePlanet!.number, planet.number, "### Flotte ist beim falschen Planeten ###")
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.number, 3, "### Flotte wurde nicht gefunden ###")
                        } else {
                            XCTFail("### Flotte 3 nicht gefunden  ###")
                        }
                        
                    } else if planet.number == 2 {
                        var oneFleetsThere = (planet.fleets.count == 1)
                        XCTAssertTrue(oneFleetsThere, "### Planet 2 hat nicht die 1 Flotte ###")
                        //Test Flotte 1
                        var fleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray!, 1)
                        
                        if fleetAndHomePlanet.homePlanet != nil && fleetAndHomePlanet.fleet != nil {
                            XCTAssertEqual(fleetAndHomePlanet.homePlanet!.number, planet.number, "### Flotte ist beim falschen Planeten ###")
                            XCTAssertEqual(fleetAndHomePlanet.fleet!.number, 1, "### Flotte wurde nicht gefunden ###")
                            XCTAssertTrue(fleetAndHomePlanet.fleet!.ships == 1,"### Flotte 1 Anzahl Schiffe falsch ###")
                            
                        } else {
                            XCTFail("### Flotte 1 nicht gefunden  ###")
                        }
                    } else if planet.number == 3 {
                        var noFleetsThere = (planet.fleets.count == 0)
                        XCTAssertTrue(noFleetsThere, "### Planet 3 hat nicht die 0 Flotten ###")
                    }
                }
                
            } else {
                XCTFail("### TestsCommandFactory.testFactory commandsString is nil ###")
            }
        } else {
            XCTFail("### TestsCommandFactory.testFactory planetArray is nil ###")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
