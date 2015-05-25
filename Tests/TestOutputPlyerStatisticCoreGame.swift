//
//  TestOutputPlyerStatisticCoreGame.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 25.05.15.
//  Copyright (c) 2015 Bernd Niklas. All rights reserved.
//

import Cocoa
import XCTest

class TestOutputPlyerStatisticCoreGame: XCTestCase {

    var planetArray: Array<Planet>?
    var allPlayerDict: [String: Player]?
    
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
            var path: String? = aBundle!.resourcePath as String?
            path = path?.stringByAppendingPathComponent("planets.plist")
            if path != nil {
                var persManager = PersistenceManager()
                
                planetArray = persManager.readPlanetPListWithPath(path!)
                allPlayerDict = persManager.allPlayerDict
                
            }
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCalculateStatistic() {
        
        if allPlayerDict != nil && planetArray != nil {
            for (playerName, player) in allPlayerDict! {
                var outPut = OutputPlyerStatisticCoreGame(aPlanets: planetArray!, aPlayer: player)
                outPut.calculateStatistic()
                XCTAssert(true, "Pass")

                
        }
        }
       //  // This is an example of a functional test case.
      //  }
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
