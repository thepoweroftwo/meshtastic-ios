//
//  User_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

class User_DO
{
    var id: String
    var longName: String
    var shortName: String
    var macaddr: Data
    
    init()
    {
        self.id = String()
        self.longName = String()
        self.shortName = String()
        self.macaddr = Data()
    }    
}
