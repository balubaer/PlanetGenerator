//
//  TestDistanceLevel.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.11.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestDistanceLevel: XCTestCase {
    var planetArray: Array<Planet>?
    var allPlayerDict: [String: Player]?
    
    func getBundle() -> NSBundle? {
        var result: NSBundle? = nil
        let array: Array = NSBundle.allBundles()
        
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
        
        let aBundle: NSBundle? = self.getBundle()
        if aBundle != nil {
            var path: NSString? = aBundle!.resourcePath
            path = path?.stringByAppendingPathComponent("planets.plist")
            if path != nil {
                let persManager = PersistenceManager()
                
                planetArray = persManager.readPlanetPListWithPath(path! as String)
                allPlayerDict = persManager.allPlayerDict
            }
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDistanceLevel() {
        if planetArray != nil && allPlayerDict != nil {
            
            var planet1 = planetWithNumber(planetArray!, number: 1)
            
            if planet1 != nil {
                var disLevel = DistanceLevel(aStartPlanet: planet1!, aDistanceLevel: 1)
                
                XCTAssertTrue(disLevel.nextLevelPlanets.count == 1, "### nextLevelPlanets Anzahl falsch ###")
                if (disLevel.nextLevelPlanets.count == 1) {
                    XCTAssertTrue(disLevel.nextLevelPlanets[0].number == 2, "### Es ist nicht Planet 2 ###")
                }
                disLevel.goNextLevel()
                XCTAssertTrue(disLevel.nextLevelPlanets.count == 1, "### nextLevelPlanets Anzahl falsch ###")
                if (disLevel.nextLevelPlanets.count == 1) {
                    XCTAssertTrue(disLevel.nextLevelPlanets[0].number == 3, "### Es ist nicht Planet 3 ###")
                }
            } else {
                XCTFail("### TestDistanceLevel.testDistanceLevel Planet 1 nicht vorhanden ###")
            }
            
        } else {
            XCTFail("### TestDistanceLevel.testDistanceLevel planetArray and allPlayerDict are nil ###")
        }
        
    }
}
