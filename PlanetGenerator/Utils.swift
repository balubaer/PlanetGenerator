//
//  Utils.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

func createBracketAndCommarStringWithStringArray(aStringArray:Array <String>) -> String {
    var result = "("
    var counter = 0
    let maxCounter = aStringArray.count - 1
    
    for string in aStringArray {
        result += string
        if counter < maxCounter {
            result += ","
        }
        counter++
    }
    result += ")"

    return result
}

func isCharacterANumber(aCharacter: Character) -> Bool {
    let tempString = "\(aCharacter)"
    let value : Int? = Int(tempString)
    var result: Bool = false
    
    if value != nil {
        result = (value >= 0 && value <= 9)
    }
    return result
}

func extractNumberString(aString: String) ->String {
    var result = String()
    for aCharacter in aString.characters {
        if isCharacterANumber(aCharacter) {
            result.append(aCharacter)
        }
    }
    return result
}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerate() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}
