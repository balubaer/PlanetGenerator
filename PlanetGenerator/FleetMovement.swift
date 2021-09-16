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
    
    func addXMLPassingOnParent(_ parent : XMLElement) {
        if fleet != nil && toPlanet != nil {
            let childElementConnect = XMLElement(name: "passing")
            if let attribute = XMLNode.attribute(withName: "index", stringValue: "\(fleet!.number)") as? XMLNode {
                childElementConnect.addAttribute(attribute)
            }
            if fleet!.player != nil {
                if let attribute = XMLNode.attribute(withName: "owner", stringValue: "\(fleet!.player!.name)") as? XMLNode {
                    childElementConnect.addAttribute(attribute)
                }
            }
            if let attribute = XMLNode.attribute(withName: "toWorld", stringValue: "\(toPlanet!.number)") as? XMLNode {
                childElementConnect.addAttribute(attribute)
            }
            parent.addChild(childElementConnect)
        }
    }

}
