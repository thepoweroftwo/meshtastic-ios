//
//  ChannelSettings_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

class ChannelSettings_DO
{
    var txPower: Int32
    var modemConfig: Enumerations.ModemConfig
    var bandwidth: UInt32
    var spreadFactor: UInt32
    var codingRate: UInt32
    var channelNum: UInt32
    var psk: Data
    var name: String
    
    init()
    {
        self.txPower = 0
        self.modemConfig = Enumerations.ModemConfig.bw125Cr45Sf128
        self.bandwidth = 0
        self.spreadFactor = 0
        self.codingRate = 0
        self.channelNum = 0
        self.psk = Data()
        self.name = String()
    }
}
