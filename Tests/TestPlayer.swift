//
//  TestPlayer.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestPlayer: XCTestCase {
    
    func testName() {
        var player = Player()
        player.name = "ZAPHOD"
        
        XCTAssertEqual("ZAPHOD", player.name, "### player.name Fehler ###")
        
        
    }
    
    func testdescription() {
        var player = Player()
        player.name = "ZAPHOD"
        
        XCTAssertEqual("[ZAPHOD]", player.description, "### player.description Fehler ###")
    }
}