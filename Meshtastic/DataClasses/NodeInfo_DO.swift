//
//  NodeInfo_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

/// NodeInfo data object
///
class NodeInfo_DO
{
    var num: UInt32
    var user: User_DO
    var hasUser: Bool
    var position: Position_DO
    var hasPosition: Bool
    var snr: Float
    var nextHop: UInt32
    
    init()
    {
        self.num = 0
        self.user = User_DO()
        self.hasUser = false
        self.position = Position_DO()
        self.hasPosition = false
        self.snr = 0
        self.nextHop = 0
    }
}
