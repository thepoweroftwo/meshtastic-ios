//
//  BLEController.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 28.09.20.
//

import Foundation
import CoreBluetooth



class BLEConroller : NSObject
{
    
    static let shared = BLEConroller() // Make it a singleton class
    
    
    //---------------------------------------------------------------------------------------
    // MARK: - class variables, constants and dataobjects
    //---------------------------------------------------------------------------------------
    var centralManager: CBCentralManager!
    var peripheralArray = [CBPeripheral]()
    var connectedDevice: CBPeripheral!
    var isBLEConnected = false
    var timeoutTimer: Timer?
    
    var masterDataProcessor: MasterDataProcessor

    
    var TORADIO_characteristic: CBCharacteristic!
    var FROMRADIO_characteristic: CBCharacteristic!
    var FROMNUM_characteristic: CBCharacteristic!
    
    let meshtasticServiceCBUUID = CBUUID(string: "0x6BA1B218-15A8-461F-9FA8-5DCAE273EAFD")
    let TORADIO_UUID = CBUUID(string: "0xF75C76D2-129E-4DAD-A1DD-7866124401E7")
    let FROMRADIO_UUID = CBUUID(string: "0x8BA2BCC2-EE02-4A55-A531-C525C5E454D5")
    let FROMNUM_UUID = CBUUID(string: "0xED9DA18C-A800-4F66-A670-AA7547E34453") //Notify
    
    

    //---------------------------------------------------------------------------------------

    
    // MARK: - Initialization
    override private init()
    {
        self.masterDataProcessor = MasterDataProcessor()
        
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    
    //---------------------------------------------------------------------------------------
    // MARK: - private functions
    //---------------------------------------------------------------------------------------
    
    /// The action after the timeout-timer has fired
    ///
    /// - Parameters:
    ///     - timer: The time that fired the event
    ///
    @objc func timeoutTimerFired(timer: Timer)
    {
        print("BLE-Timeout-Timer fired!")
        timer.invalidate()
        MasterViewController.shared.bleConnectionTimeout()
    }
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // public functions
    //---------------------------------------------------------------------------------------

    // MARK: - functions for use by MasterViewontroller

    /// Estabishes a connection to a device
    ///
    /// - Parameters:
    ///     - peripheral: The device to establish the connection with
    ///
    public func connectToDevice(peripheral: CBPeripheral)
    {
        self.timeoutTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timeoutTimerFired), userInfo: nil, repeats: true)
        centralManager.connect(peripheral)
    }
    
    
    /// Disconnects from a device
    ///
    /// - Parameters:
    ///     - peripheral: The device to disconnect from
    ///
    public func disconnectFromDevice(peripheral: CBPeripheral)
    {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    
    public func cancelConnect()
    {
        if (self.connectedDevice != nil)
        {
            centralManager.cancelPeripheralConnection(self.connectedDevice)
        }
    }
    
    
    /// Scanns the BLE adverstisement data
    ///
    public func rescanForDevices()
    {
        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    
    public func sendMessage(message: String, toUserID: String)
    {
        var toNodeID: UInt32
        let nodeInfo_DP = NodeInfo_DP()
        var toNode = NodeInfo_DO()
        var fromNode = NodeInfo_DO()
        let chatMessagr_DP = ChatMessage_DP()
        let chatMessage = ChatMessage_DO()

        
        if (toUserID == "BC")
        {
            toNodeID = DataBase.shared.broadcastNodeId
        }
        else
        {
            toNodeID = nodeInfo_DP.getNodeIdByUserId(userId: toUserID)
            toNode = nodeInfo_DP.dbRead(nodeId: toNodeID)!
            fromNode = nodeInfo_DP.getMyNodeObject()!
            
            chatMessage.messageID = 0
            chatMessage.messageTimestamp = Date.currentTimeStamp
            chatMessage.fromUserID = fromNode.user.id
            chatMessage.fromUserLongName = fromNode.user.longName
            chatMessage.toUserID = toNode.user.id
            chatMessage.toUserLongName = toNode.user.longName
            chatMessage.messagePayload = message
            chatMessage.direction = "OUT"
            chatMessagr_DP.dbWrite(chatMessage)
            MasterViewController.shared.chatMessageUpdated()
        }
        
        let dataType = PortNum.textMessageApp
        //let BROADCAST_ADDR = 0xffffffff
        let payloadData: Data = message.data(using: String.Encoding.utf8)!
    
        var subPacket = SubPacket()
        subPacket.data.payload = payloadData
        subPacket.data.portnum = dataType
        
        var meshPacket = MeshPacket()
        //meshPacket.to = UInt32(BROADCAST_ADDR)
        meshPacket.to = toNodeID
        meshPacket.decoded = subPacket
        meshPacket.wantAck = true
        
        var toRadio: ToRadio!
        toRadio = ToRadio()
        toRadio.packet = meshPacket

        let binaryData: Data = try! toRadio.serializedData()
        if (connectedDevice.state == CBPeripheralState.connected)
        {
            connectedDevice.writeValue(binaryData, for: TORADIO_characteristic, type: .withResponse)
            MasterViewController.shared.DebugPrint2View(text: message + "\n\r")
        }
        else
        {
            connectToDevice(peripheral: self.connectedDevice)
        }
    }

    
    public func setOwner(myUser: User)
    {
        var toRadio: ToRadio!
        toRadio = ToRadio()
        toRadio.setOwner = myUser
        
        let binaryData: Data = try! toRadio.serializedData()
        if (connectedDevice.state == CBPeripheralState.connected)
        {
            connectedDevice.writeValue(binaryData, for: TORADIO_characteristic, type: .withResponse)
            MasterViewController.shared.DebugPrint2View(text: "Owner set to device" + "\n\r")
        }
        else
        {
            connectToDevice(peripheral: self.connectedDevice)
        }
    }

    
    
    
    public func writeRadioConfig(userPreferences: RadioConfig.UserPreferences, channelSettings: ChannelSettings)
    {
        var toRadio: ToRadio!
        toRadio = ToRadio()
        toRadio.setRadio.channelSettings = channelSettings
        toRadio.setRadio.preferences = userPreferences
        
        let binaryData: Data = try! toRadio.serializedData()
        if (connectedDevice.state == CBPeripheralState.connected)
        {
            connectedDevice.writeValue(binaryData, for: TORADIO_characteristic, type: .withResponse)
            MasterViewController.shared.DebugPrint2View(text: "RadioConfig written to device" + "\n\r")
        }
        else
        {
            connectToDevice(peripheral: self.connectedDevice)
        }
        
    }
    
    
    
    //---------------------------------------------------------------------------------------

}


//---------------------------------------------------------------------------------------
// MARK: - BLE controller extension (delegate callbacks)
//---------------------------------------------------------------------------------------

extension BLEConroller: CBCentralManagerDelegate
{
    //---------------------------------------------------------------------------------------
    // Advertisement and Connection
    //---------------------------------------------------------------------------------------

    
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
            case .unknown:
                print("central.state is .unknown")
            case .resetting:
                print("central.state is .resetting")
            case .unsupported:
                print("central.state is .unsupported")
            case .unauthorized:
                print("central.state is .unauthorized")
            case .poweredOff:
                print("central.state is .poweredOff")
            case .poweredOn:
                print("central.state is .poweredOn")
                centralManager.scanForPeripherals(withServices: nil)
            @unknown default:
                break
        }
    }
 
    
    // Scan advertisement data
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber)
    {
        if ((peripheral.name?.hasPrefix("Meshtastic")) == true)
        {
            print(peripheral)
            MasterViewController.shared.updateDeviceList(peripheral: peripheral)
        }
    }
    

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral)
    {
        print("Connected: " + peripheral.name!)
        self.timeoutTimer?.invalidate()
        isBLEConnected = true
        connectedDevice = peripheral
        connectedDevice.delegate = self        
        
        MasterViewController.shared.updateDeviceList(peripheral: peripheral)

        centralManager.stopScan()
        MasterViewController.shared.didConnectToDevice()
        connectedDevice.discoverServices(nil)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?)
    {
        isBLEConnected = false
        //connectedDevice = nil
        print("Disconnected: " + peripheral.name!)
        MasterViewController.shared.DebugPrint2View(text: "!!! Disconnected: " + peripheral.name! + "\n\r")
        centralManager.scanForPeripherals(withServices: nil)
    }
    
}


//---------------------------------------------------------------------------------------
// MARK: - BLE peripheral extension (delegate callbacks)
//---------------------------------------------------------------------------------------

extension BLEConroller: CBPeripheralDelegate
{
    //---------------------------------------------------------------------------------------
    // Discover Services and Characteristics
    //---------------------------------------------------------------------------------------

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        guard let services = peripheral.services else { return }
        
        for service in services
        {
    //            print(service)
            
            if (service.uuid == meshtasticServiceCBUUID)
            {
                print ("Meshtastic service OK")
                
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
      guard let characteristics = service.characteristics else { return }

      for characteristic in characteristics
      {
//        print(characteristic)
        
        switch characteristic.uuid
        {
            case TORADIO_UUID:
                print("TORADIO characteristic OK")
                TORADIO_characteristic = characteristic
                var toRadio: ToRadio = ToRadio()
                toRadio.wantConfigID = 32168
                let binaryData: Data = try! toRadio.serializedData()
                peripheral.writeValue(binaryData, for: characteristic, type: .withResponse)
                break
            
            case FROMRADIO_UUID:
                print("FROMRADIO characteristic OK")
                FROMRADIO_characteristic = characteristic
                peripheral.readValue(for: FROMRADIO_characteristic)
                break
            
            case FROMNUM_UUID:
                print("FROMNUM (Notify) characteristic OK")
                FROMNUM_characteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                break
            
            default:
                break
        }
      }
    }

    //---------------------------------------------------------------------------------------

    
    
    //---------------------------------------------------------------------------------------
    // Data read
    //---------------------------------------------------------------------------------------

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        switch characteristic.uuid
        {
            case FROMNUM_UUID:
                peripheral.readValue(for: FROMRADIO_characteristic)

            case FROMRADIO_UUID:
                if (characteristic.value == nil || characteristic.value!.isEmpty)
                {
                    return
                }
                
                print(characteristic.value ?? "no value")
            //            let byteArray = [UInt8](characteristic.value!)
            //            print(characteristic.value?.hexDescription ?? "no value")
            //            viewController.txtView1.text! += characteristic.value!.hexDescription
                MasterViewController.shared.DebugPrint2View(text: "\n\r-----------------------------------\n\r")
                var decodedInfo = FromRadio()
                decodedInfo = try! FromRadio(serializedData: characteristic.value!)
                print(decodedInfo)
                MasterViewController.shared.DebugPrint2View(text: decodedInfo.debugDescription)
                
                self.masterDataProcessor.parseFromRadioPb(fromRadioDecoded: decodedInfo)
                
            default:
                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
        
        peripheral.readValue(for: FROMRADIO_characteristic)
        
    }

    
    //---------------------------------------------------------------------------------------


}

//---------------------------------------------------------------------------------------


//extension Data
//{
//    var hexDescription: String
//    {
//        return reduce("") {$0 + String(format: "%02x", $1)}
//    }
//}
//
//
//extension String {
//
//    /// Create `Data` from hexadecimal string representation
//    ///
//    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
//    ///
//    /// - returns: Data represented by this hexadecimal string.
//
//    var hexadecimal: Data? {
//        var data = Data(capacity: count / 2)
//
//        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
//        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
//            let byteString = (self as NSString).substring(with: match!.range)
//            let num = UInt8(byteString, radix: 16)!
//            data.append(num)
//        }
//
//        guard data.count > 0 else { return nil }
//
//        return data
//    }
//
//}


