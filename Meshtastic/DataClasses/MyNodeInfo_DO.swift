//
//  MyNodeInfo_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

class MyNodeInfo_DO
{
    var myNodeNum: UInt32
    var hasGps_p: Bool
    var numChannels: Int32
    var region: String
    var hwModel: String
    var firmwareVersion: String
    var errorCode: UInt32
    var errorAddress: UInt32
    var errorCount: UInt32
    var packetIDBits: UInt32
    var currentPacketID: UInt32
    var nodeNumBits: UInt32
    var messageTimeoutMsec: UInt32
    var minAppVersion: UInt32
    
    init()
    {
        self.myNodeNum = 0
        self.hasGps_p = false
        self.numChannels = 0
        self.region = String()
        self.hwModel = String()
        self.firmwareVersion = String()
        self.errorCode = 0
        self.errorAddress = 0
        self.errorCount = 0
        self.packetIDBits = 0
        self.currentPacketID = 0
        self.nodeNumBits = 0
        self.messageTimeoutMsec = 0
        self.minAppVersion = 0
    }
}
