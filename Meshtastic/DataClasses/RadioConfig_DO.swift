//
//  RadioConfig_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

class RadioConfig_DO
{
    var preferences: UserPreferences_DO
    var hasPreferences: Bool
    var channelSettings: ChannelSettings_DO
    var hasChannelSettings: Bool
    
    init()
    {
        self.preferences = UserPreferences_DO()
        self.hasPreferences = false
        self.channelSettings = ChannelSettings_DO()
        self.hasChannelSettings = false
    }
}
