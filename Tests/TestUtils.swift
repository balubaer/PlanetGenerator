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
        let stringArray = ["Bastian", "Jonathan", "Anke", "Bernd"]
        let aString = createBracketAndCommarStringWithStringArray(stringArray)
        
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
    
    func testRemoveFromArray() {
        var list = [1,2,3]
        list.removeObject(2) // Successfully removes 2 because types matched
        
        XCTAssertTrue(list.count == 2, "### removeObject Fehler ###")

        list.removeObject("3") // fails silently to remove anything because the types don't match
        XCTAssertTrue(list.count == 2, "### removeObject Fehler ###")
        var counter = 0
        for aInt in list {
            if counter == 0 {
                XCTAssertTrue(aInt == 1, "### removeObject Fehler ###")
            } else if counter == 1 {
                XCTAssertTrue(aInt == 3, "### removeObject Fehler ###")
            }
            counter += 1
        }
    }
}
