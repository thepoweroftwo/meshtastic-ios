//
//  MasterDataProcessor.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.10.20.
//

import Foundation

class MasterDataProcessor
{
    var radio: RadioConfig_DO
    var preferences: UserPreferences_DO
    var channelSettings: ChannelSettings_DO
    var nodeInfo: NodeInfo_DO
    var user: User_DO
    var position: Position_DO
    var myInfo: MyNodeInfo_DO
        
    
    init()
    {
        radio = RadioConfig_DO()
        preferences = UserPreferences_DO()
        channelSettings = ChannelSettings_DO()
        nodeInfo = NodeInfo_DO()
        user = User_DO()
        position = Position_DO()
        myInfo = MyNodeInfo_DO()
    }
    
    
    /// Parse the decoded protoBuf structure "FromRadio" and write the data into our own data classes
    public func parseFromRadioPb(fromRadioDecoded: FromRadio)
    {
        var pbDataType: FromRadio.OneOf_Variant
        pbDataType = fromRadioDecoded.variant!
        
        if (pbDataType == FromRadio.OneOf_Variant.packet(fromRadioDecoded.packet))
        {
            print("######## MeshPacket ########")
            let meshPacket = fromRadioDecoded.packet
            let mpDataType = meshPacket.payload
            if (mpDataType == MeshPacket.OneOf_Payload.decoded(meshPacket.decoded))
            {
                print("######## MeshPacket.Decoded ########")
                let subPacket = meshPacket.decoded
                let sbDataType = subPacket.payload
                if (sbDataType == SubPacket.OneOf_Payload.position(subPacket.position))
                {
                    print("######## MeshPacket.Decoded.SubPacket.Position ########")

                }
                else if (sbDataType == SubPacket.OneOf_Payload.data(subPacket.data))
                {
                    print("######## MeshPacket.Decoded.SubPacket.DataMessage ########")

                }
                else if (sbDataType == SubPacket.OneOf_Payload.user(subPacket.user))
                {
                    print("######## MeshPacket.Decoded.SubPacket.User ########")

                }
            }
            else if (mpDataType == MeshPacket.OneOf_Payload.encrypted(meshPacket.encrypted))
            {
                print("######## MeshPacket.Encrypted ########")
                // We have nothing to do here
            }
        }
        else if (pbDataType == FromRadio.OneOf_Variant.radio(fromRadioDecoded.radio) )
        {
            print("######## RadioConfig ########")
            self.radio.hasPreferences = fromRadioDecoded.radio.hasPreferences
            self.radio.hasChannelSettings = fromRadioDecoded.radio.hasChannelSettings
            if (self.radio.hasPreferences)
            {
                self.preferences.positionBroadcastSecs = fromRadioDecoded.radio.preferences.positionBroadcastSecs
                self.preferences.sendOwnerInterval = fromRadioDecoded.radio.preferences.sendOwnerInterval
                self.preferences.numMissedToFail = fromRadioDecoded.radio.preferences.numMissedToFail
                self.preferences.waitBluetoothSecs = fromRadioDecoded.radio.preferences.waitBluetoothSecs
                self.preferences.screenOnSecs = fromRadioDecoded.radio.preferences.screenOnSecs
                self.preferences.phoneTimeoutSecs = fromRadioDecoded.radio.preferences.phoneTimeoutSecs
                self.preferences.phoneSdsTimeoutSec = fromRadioDecoded.radio.preferences.phoneSdsTimeoutSec
                self.preferences.meshSdsTimeoutSecs = fromRadioDecoded.radio.preferences.meshSdsTimeoutSecs
                self.preferences.sdsSecs = fromRadioDecoded.radio.preferences.sdsSecs
                self.preferences.lsSecs = fromRadioDecoded.radio.preferences.lsSecs
                self.preferences.minWakeSecs = fromRadioDecoded.radio.preferences.minWakeSecs
                self.preferences.wifiSsid = fromRadioDecoded.radio.preferences.wifiSsid
                self.preferences.wifiPassword = fromRadioDecoded.radio.preferences.wifiPassword
                self.preferences.wifiApMode = fromRadioDecoded.radio.preferences.wifiApMode
                self.preferences.ignoreIncoming = fromRadioDecoded.radio.preferences.ignoreIncoming
                self.radio.preferences = self.preferences
            }
            
            if (self.radio.hasChannelSettings)
            {
                self.channelSettings.txPower = fromRadioDecoded.radio.channelSettings.txPower
                switch fromRadioDecoded.radio.channelSettings.modemConfig
                {
                    case ChannelSettings.ModemConfig.bw125Cr45Sf128 :
                        self.channelSettings.modemConfig = Enumerations.ModemConfig.bw125Cr45Sf128
                    case ChannelSettings.ModemConfig.bw500Cr45Sf128 :
                        self.channelSettings.modemConfig = Enumerations.ModemConfig.bw500Cr45Sf128
                    case ChannelSettings.ModemConfig.bw3125Cr48Sf512 :
                        self.channelSettings.modemConfig = Enumerations.ModemConfig.bw3125Cr48Sf512
                    case ChannelSettings.ModemConfig.bw125Cr48Sf4096 :
                        self.channelSettings.modemConfig = Enumerations.ModemConfig.bw125Cr48Sf4096
                    default:
                        self.channelSettings.modemConfig = Enumerations.ModemConfig.bw125Cr48Sf4096
                }
                self.channelSettings.bandwidth = fromRadioDecoded.radio.channelSettings.bandwidth
                self.channelSettings.spreadFactor = fromRadioDecoded.radio.channelSettings.spreadFactor
                self.channelSettings.codingRate = fromRadioDecoded.radio.channelSettings.codingRate
                self.channelSettings.channelNum = fromRadioDecoded.radio.channelSettings.channelNum
                self.channelSettings.psk = fromRadioDecoded.radio.channelSettings.psk
                self.channelSettings.name = fromRadioDecoded.radio.channelSettings.name
                
                self.radio.channelSettings = self.channelSettings
                MasterViewController.shared.updateFromDevice(radioConfig: self.radio)
            }
        }
        else if (pbDataType == FromRadio.OneOf_Variant.nodeInfo(fromRadioDecoded.nodeInfo) )
        {
            print("######## NodeInfo ########")
            self.nodeInfo.num = fromRadioDecoded.nodeInfo.num
            self.nodeInfo.hasUser = fromRadioDecoded.nodeInfo.hasUser
            self.nodeInfo.hasPosition = fromRadioDecoded.nodeInfo.hasPosition
            self.nodeInfo.snr = fromRadioDecoded.nodeInfo.snr
            self.nodeInfo.nextHop = fromRadioDecoded.nodeInfo.nextHop
            if (self.nodeInfo.hasUser)
            {
                self.user.id = fromRadioDecoded.nodeInfo.user.id
                self.user.longName = fromRadioDecoded.nodeInfo.user.longName
                self.user.shortName = fromRadioDecoded.nodeInfo.user.shortName
                self.user.macaddr = fromRadioDecoded.nodeInfo.user.macaddr
                self.nodeInfo.user = self.user
            }
            
            if (nodeInfo.hasPosition)
            {
                self.position.latitudeI = fromRadioDecoded.nodeInfo.position.latitudeI
                self.position.longitudeI = fromRadioDecoded.nodeInfo.position.longitudeI
                self.position.altitude = fromRadioDecoded.nodeInfo.position.altitude
                self.position.batteryLevel = fromRadioDecoded.nodeInfo.position.batteryLevel
                self.position.time = fromRadioDecoded.nodeInfo.position.time
                self.nodeInfo.position = self.position
            }
        }
        else if (pbDataType == FromRadio.OneOf_Variant.myInfo(fromRadioDecoded.myInfo) )
        {
            print("######## MyInfo ########")
            self.myInfo.myNodeNum = fromRadioDecoded.myInfo.myNodeNum
            self.myInfo.hasGps_p = fromRadioDecoded.myInfo.hasGps_p
            self.myInfo.numChannels = fromRadioDecoded.myInfo.numChannels
            self.myInfo.region = fromRadioDecoded.myInfo.region
            self.myInfo.hwModel = fromRadioDecoded.myInfo.hwModel
            self.myInfo.firmwareVersion = fromRadioDecoded.myInfo.firmwareVersion
            self.myInfo.errorCode = fromRadioDecoded.myInfo.errorCode
            self.myInfo.errorAddress = fromRadioDecoded.myInfo.errorAddress
            self.myInfo.errorCount = fromRadioDecoded.myInfo.errorCount
            self.myInfo.packetIDBits = fromRadioDecoded.myInfo.packetIDBits
            self.myInfo.currentPacketID = fromRadioDecoded.myInfo.currentPacketID
            self.myInfo.nodeNumBits = fromRadioDecoded.myInfo.nodeNumBits
            self.myInfo.messageTimeoutMsec = fromRadioDecoded.myInfo.messageTimeoutMsec
            self.myInfo.minAppVersion = fromRadioDecoded.myInfo.minAppVersion
        }
        else if (pbDataType == FromRadio.OneOf_Variant.configCompleteID(fromRadioDecoded.configCompleteID) )
        {
            print("######## ConfigCompleteID ########")
        }
        else if (pbDataType == FromRadio.OneOf_Variant.rebooted(fromRadioDecoded.rebooted) )
        {
            print("######## Rebooted ########")
        }

    }
    
    
    
    
    
    
    
}
