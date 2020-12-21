//
//  DataMessage_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 19.12.20.
//

import Foundation

class DataMessage_DO
{
    //var typ: Enumerations.TypeEnum
    var portnum: Enumerations.PortNum
    var payload: Data
    
    init()
    {
        self.portnum = Enumerations.PortNum.unknownApp
        self.payload = Data()
    }
}
