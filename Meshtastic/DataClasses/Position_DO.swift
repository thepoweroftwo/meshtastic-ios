//
//  Position_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

class Position_DO
{
    var latitudeI: Int32
    var longitudeI: Int32
    var altitude: Int32
    var batteryLevel: Int32
    var time: UInt32
    
    init()
    {
        self.latitudeI = 0
        self.longitudeI = 0
        self.altitude = 0
        self.batteryLevel = 0
        self.time = 0
    }
}
