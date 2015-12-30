//
//  FleetMovement.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class FleetMovement {
    var fleet: Fleet?
    var toPlanet: Planet?
    var fromPlanet: Planet?
    var isMovementDone: Bool = false
    
    var description: String {
        var desc = "(---)"
        if fleet != nil && toPlanet != nil {
            desc = "\(fleet!.name)-->\(toPlanet!.name)"
        }
        return desc
    }
    
    init() {
    }
    
    func addXMLPassingOnParent(parent : NSXMLElement) {
        if fleet != nil && toPlanet != nil {
            let childElementConnect = NSXMLElement(name: "passing")
            if let attribute = NSXMLNode.attributeWithName("index", stringValue: "\(fleet!.number)") as? NSXMLNode {
                childElementConnect.addAttribute(attribute)
            }
            if fleet!.player != nil {
                if let attribute = NSXMLNode.attributeWithName("owner", stringValue: "\(fleet!.player!.name)") as? NSXMLNode {
                    childElementConnect.addAttribute(attribute)
                }
            }
            if let attribute = NSXMLNode.attributeWithName("toWorld", stringValue: "\(toPlanet!.number)") as? NSXMLNode {
                childElementConnect.addAttribute(attribute)
            }
            parent.addChild(childElementConnect)
        }
    }

}