//
//  Utils.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


func createBracketAndCommarStringWithStringArray(_ aStringArray:Array <String>) -> String {
    var result = "("
    var counter = 0
    let maxCounter = aStringArray.count - 1
    
    for string in aStringArray {
        result += string
        if counter < maxCounter {
            result += ","
        }
        counter += 1
    }
    result += ")"

    return result
}

func isCharacterANumber(_ aCharacter: Character) -> Bool {
    let tempString = "\(aCharacter)"
    let value : Int? = Int(tempString)
    var result: Bool = false
    
    if value != nil {
        result = (value >= 0 && value <= 9)
    }
    return result
}

func extractNumberString(_ aString: String) ->String {
    var result = String()
    for aCharacter in aString.characters {
        if isCharacterANumber(aCharacter) {
            result.append(aCharacter)
        }
    }
    return result
}

extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}
