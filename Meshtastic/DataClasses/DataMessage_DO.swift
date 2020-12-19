//
//  DataMessage_DO.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 19.12.20.
//

import Foundation

class DataMessage_DO
{
    var typ: Enumerations.TypeEnum
    var payload: Data
    
    init()
    {
        self.typ = Enumerations.TypeEnum.opaque
        self.payload = Data()
    }
}
