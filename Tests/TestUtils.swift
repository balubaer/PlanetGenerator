//
//  TestUtils.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestUtils: XCTestCase {
    
    func testCreateBracketAndCommarStringWithStringArray() {
        var stringArray = ["Bastian", "Jonathan", "Anke", "Bernd"]
        var aString = createBracketAndCommarStringWithStringArray(stringArray)
        
        XCTAssertEqual("(Bastian,Jonathan,Anke,Bernd)", aString, "### createBracketAndCommarStringWithStringArray Fehler ###")
    }
}
