//
//  UserPreferences_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

class UserPreferences_DO
{    
    var positionBroadcastSecs: UInt32
    var sendOwnerInterval: UInt32
    var numMissedToFail: UInt32
    var waitBluetoothSecs: UInt32
    var screenOnSecs: UInt32
    var phoneTimeoutSecs: UInt32
    var phoneSdsTimeoutSec: UInt32
    var meshSdsTimeoutSecs: UInt32
    var sdsSecs: UInt32
    var lsSecs: UInt32
    var minWakeSecs: UInt32
    var wifiSsid: String
    var wifiPassword: String
    var wifiApMode: Bool
    var ignoreIncoming: [UInt32]
    
    init ()
    {
        self.positionBroadcastSecs = 0
        self.sendOwnerInterval = 0
        self.numMissedToFail = 0
        self.waitBluetoothSecs = 0
        self.screenOnSecs = 0
        self.phoneTimeoutSecs = 0
        self.phoneSdsTimeoutSec = 0
        self.meshSdsTimeoutSecs = 0
        self.sdsSecs = 0
        self.lsSecs = 0
        self.minWakeSecs = 0
        self.wifiSsid = String()
        self.wifiPassword = String()
        self.wifiApMode = false
        self.ignoreIncoming = []
    }
}
