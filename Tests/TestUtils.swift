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
    
    func testIsCharacterANumber() {
        XCTAssertTrue(isCharacterANumber("0"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("1"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("2"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("3"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("4"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("5"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("6"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("7"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("8"), "### isCharacterANumber Fehler ###")
        XCTAssertTrue(isCharacterANumber("9"), "### isCharacterANumber Fehler ###")

        XCTAssertFalse(isCharacterANumber("A"), "### isCharacterANumber Fehler ###")
        XCTAssertFalse(isCharacterANumber("Z"), "### isCharacterANumber Fehler ###")
        XCTAssertFalse(isCharacterANumber("a"), "### isCharacterANumber Fehler ###")
        XCTAssertFalse(isCharacterANumber("z"), "### isCharacterANumber Fehler ###")

    }
}
