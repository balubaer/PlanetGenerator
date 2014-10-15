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
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFactory() {
        
        XCTAssertNotNil(commandsString, "### commandsString Fehler ###")
       // var commandFactory = CommandFactory(aPlanetArray: Array <Planet>, aFleetArray: Array <Fleet>
        
        XCTAssertTrue(true, "### factory Fehler ###")

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
