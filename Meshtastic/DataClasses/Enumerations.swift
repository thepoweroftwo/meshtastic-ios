//
//  Enumerations.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 02.10.20.
//

import Foundation

class Enumerations
{
    enum ModemConfig
    {
        case bw125Cr45Sf128 // = 0

        /// on. Default medium range
        case bw500Cr45Sf128 // = 1

        /// on. Fast+short range
        case bw3125Cr48Sf512 // = 2

        /// CRC on. Slow+long range
        case bw125Cr48Sf4096 // = 3
        case UNRECOGNIZED(Int)
        
        typealias RawValue = Int
        var rawValue: Int
        {
            switch self
            {
                case .bw125Cr45Sf128: return 0
                case .bw500Cr45Sf128: return 1
                case .bw3125Cr48Sf512: return 2
                case .bw125Cr48Sf4096: return 3
                case .UNRECOGNIZED(let i): return i
            }
        }
        
        typealias Description = String
        var description: String
        {
            switch self
            {
                case .bw125Cr45Sf128: return "bw125Cr45Sf128"
                case .bw500Cr45Sf128: return "bw500Cr45Sf128"
                case .bw3125Cr48Sf512: return "bw3125Cr48Sf512"
                case .bw125Cr48Sf4096: return "bw125Cr48Sf4096"
                case .UNRECOGNIZED(let i): return String(i)
            }
        }
        
        init?(rawValue: Int)
        {
            switch rawValue
            {
                case 0: self = .bw125Cr45Sf128
                case 1: self = .bw500Cr45Sf128
                case 2: self = .bw3125Cr48Sf512
                case 3: self = .bw125Cr48Sf4096
                default: self = .UNRECOGNIZED(rawValue)
            }
        }        
    }
    
   
    /// Deprecated, use new ProtNum structure
    ///
    enum TypeEnum
    {
        //// A message sent from a device outside of the mesh, in a form the mesh
        //// does not understand
        case opaque // = 0

        //// a simple UTF-8 text message, which even the little micros in the mesh
        //// can understand and show on their screen eventually in some circumstances
        //// even signal might send messages in this form (see below)
        case clearText // = 1

        //// a message receive acknowledgement, sent in cleartext - allows radio to
        //// show user that a message has been read by the recipient, optional
        case clearReadack // = 2
        case UNRECOGNIZED(Int)
        
        typealias RawValue = Int
        var rawValue: Int
        {
            switch self
            {
                case .opaque: return 0
                case .clearText: return 1
                case .clearReadack: return 2
                case .UNRECOGNIZED(let i): return i
            }
        }

        init()
        {
            self = .opaque
        }

        init?(rawValue: Int)
        {
            switch rawValue
            {
                case 0: self = .opaque
                case 1: self = .clearText
                case 2: self = .clearReadack
                default: self = .UNRECOGNIZED(rawValue)
            }
        }
    }
    
    
    enum PortNum
    {
        typealias RawValue = Int

        ///* Deprecated: do not use in new code (formerly called OPAQUE)
        ///A message sent from a device outside of the mesh, in a form the mesh
        ///does not understand
        ///NOTE: This must be 0, because it is documented in IMeshService.aidl to be so
        case unknownApp // = 0

        ///* a simple UTF-8 text message, which even the little micros in the mesh
        ///can understand and show on their screen eventually in some circumstances
        ///even signal might send messages in this form (see below)
        ///Formerly called CLEAR_TEXT
        case textMessageApp // = 1

        ///* Reserved for built-in GPIO/example app.
        ///See remote_hardware.proto/HardwareMessage for details on the message sent/received to this port number
        case remoteHardwareApp // = 2

        ///* The built-in position messaging app.
        ///See Position for details on the message sent to this port number.
        case positionApp // = 3

        ///* The built-in user info app.
        ///See User for details on the message sent to this port number.
        case nodeinfoApp // = 4

        ///* Provides a 'ping' service that replies to any packet it receives.  Also this serves as a
        ///small example plugin.
        case replyApp // = 32

        ///* Private applications should use portnums >= 256.  To simplify initial development and testing you can use "PRIVATE_APP"
        ///in your code without needing to rebuild protobuf files (via bin/regin_protos.sh)
        case privateApp // = 256

        ///* 1024-66559 Are reserved for use by IP tunneling (see FIXME for more information)
        case ipTunnelApp // = 1024
        case UNRECOGNIZED(Int)

        init()
        {
            self = .unknownApp
        }

        init?(rawValue: Int)
        {
            switch rawValue
            {
                case 0: self = .unknownApp
                case 1: self = .textMessageApp
                case 2: self = .remoteHardwareApp
                case 3: self = .positionApp
                case 4: self = .nodeinfoApp
                case 32: self = .replyApp
                case 256: self = .privateApp
                case 1024: self = .ipTunnelApp
                default: self = .UNRECOGNIZED(rawValue)
            }
        }

        var rawValue: Int
        {
            switch self
            {
                case .unknownApp: return 0
                case .textMessageApp: return 1
                case .remoteHardwareApp: return 2
                case .positionApp: return 3
                case .nodeinfoApp: return 4
                case .replyApp: return 32
                case .privateApp: return 256
                case .ipTunnelApp: return 1024
                case .UNRECOGNIZED(let i): return i
            }
        }
    }
    
    
    
    
    
    
    
}
