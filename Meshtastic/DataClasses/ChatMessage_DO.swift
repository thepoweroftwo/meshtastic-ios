//
//  ChatMessage_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 23.01.21.
//

import Foundation

class ChatMessage_DO
{    
    var messageID: UInt32
    var messageTimestamp: Int64
    var fromUserID: String
    var toUserID: String
    var fromUserLongName: String
    var toUserLongName: String
    var receivedACK: Bool
    var messagePayload: String
    
    init()
    {
        self.messageID = UInt32()
        self.messageTimestamp = Int64()
        self.fromUserID = String()
        self.toUserID = String()
        self.fromUserLongName = String()
        self.toUserLongName = String()
        self.receivedACK = Bool()
        self.messagePayload = String()
    }

}
