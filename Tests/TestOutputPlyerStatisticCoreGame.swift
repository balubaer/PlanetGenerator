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
            if let path = aBundle!.resourcePath as String? {
                var urlPath = NSURL(fileURLWithPath: path)
                urlPath = urlPath.URLByAppendingPathComponent("planets.plist")
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

    func testCalculateStatistic() {
        
        if allPlayerDict != nil && planetArray != nil {
            for (_, player) in allPlayerDict! {
                let outPut = OutputPlyerStatisticCoreGame(aPlanets: planetArray!, aPlayer: player)
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
