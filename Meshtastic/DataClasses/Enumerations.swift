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
        var rawValue: Int {
          switch self {
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
            switch self {
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
    
   
    
    
}
