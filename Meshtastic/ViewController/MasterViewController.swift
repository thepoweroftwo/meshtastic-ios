//
//  MasterViewController.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 28.09.20.
//



import Foundation
import UIKit
import CoreBluetooth


class MasterViewController
{
    static let shared = MasterViewController() // Make it a singleton class

    //---------------------------------------------------------------------------------------
    // MARK: - class variables and dataobjects
    //---------------------------------------------------------------------------------------
    var tvcBLEDevices: tvcBLEDevices
    var tbcDeviceDetails: tbcDeviceDetails!
    var tvcChats: tvcChats!
    var vcChat: vcChat!
    var dialogMessage: UIAlertController
    var currentViewController: UIViewController!
    var masterDataProcessor: MasterDataProcessor
    //---------------------------------------------------------------------------------------


    //---------------------------------------------------------------------------------------
    // public methods
    //---------------------------------------------------------------------------------------
    
    // MARK: - methods for use by BLEController
    
    /// Called by BLEController after receiving advertisement data.
    ///
    /// - Parameters:
    ///     - peripheral: The device that sent the data
    ///
    public func updateDeviceList(peripheral: CBPeripheral)
    {
        if (self.tvcBLEDevices.isKind(of: Meshtastic.tvcBLEDevices.self))
        {
            print("TableViewController initialized")
            self.tvcBLEDevices.Add_Update_Item(peripheral)            
        }
    }

    
    /// Called by BLEController after a connection to a device was established.
    ///
    public func didConnectToDevice()
    {
        self.dialogMessage.dismiss(animated: true, completion: nil)

        if (self.currentViewController == tvcBLEDevices)
        {
            if (self.tvcChats != nil)
            {
                self.tvcChats.Add_Update_Item()
            }
            show_tbcDeviceDetails()
        }
    }
    
    
    /// Called by BLEController. If a device is allready connected we only need to present the Details tabcontroller
    ///
    public func show_tbcDeviceDetails()
    {
        let navigator: UINavigationController = tvcBLEDevices.navigationController!
        if (self.tbcDeviceDetails == nil)
        {
            if let viewController: tbcDeviceDetails = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tbcDeviceDetails") as? tbcDeviceDetails)
            {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        else
        {
            navigator.pushViewController(self.tbcDeviceDetails, animated: true)
        }
    }
    
    
    /// Called by BLEController after a connection timeout event was fired by the apprpriate timer
    ///
    public func bleConnectionTimeout()
    {
        /// - ToDo: Find the current View Controller
       
        // Create new Alert
        self.dialogMessage = UIAlertController(title: "Connection Timeout", message: "Please activate your device or press cancel to stop connection retry", preferredStyle: .alert)
        
        // Create OK button with action handler
        let cancel = UIAlertAction(title: "cancel connecting", style: .default, handler: { (action) -> Void in
            print("Cancel button tapped")
            BLEConroller.shared.cancelConnect()
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(cancel)

        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        keyWindow?.rootViewController?.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    /// Called by BLEController after a disconnect occured that was not initiated by the user
    ///
    public func bleDisconnected()
    {
        let navigator: UINavigationController = tvcBLEDevices.navigationController!
        navigator.popToRootViewController(animated: true)
        tvcBLEDevices.dataChangedHandler(nil)
        // Create new Alert
        self.dialogMessage = UIAlertController(title: "Connection lost", message: "Please reconnect your device.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.rootViewController?.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    public func DebugPrint2View(text: String)
    {
        self.tbcDeviceDetails.DebugPrint2View(text: text)
    }

    
    // MARK: - methods for use by MasterDataProcessor

    /// Called by MasterDataProcessor after radioConfig has been updated by device
    ///
    /// - Parameters:
    ///     - radioConfig: the dataobject that holds the updated data
    ///
    public func updateFromDevice(radioConfig: RadioConfig_DO)
    {
        self.tbcDeviceDetails.refreshRadioConfigData(radioConfig: radioConfig)
    }

    
    /// Called by MasterDataProcessor after user has been updated by device
    ///
    public func userUpdated(user: User_DO)
    {
        if (self.tvcChats != nil)
        {
            if (self.tvcChats.tableView != nil)
            {
                self.tvcChats.Add_Update_Item()
            }
            else
            {
                self.tvcChats.needsReload = true
            }
        }
    }

    
    /// Called by MasterDataProcessor after node has been updated by device
    ///
    public func nodeUpdated()
    {
        
    }
    
    
    /// Called by MasterDataProcessor after chat-message update by device
    ///
    public func chatMessageUpdated()
    {
        if (self.vcChat != nil)
        {
            if (self.vcChat.tableView != nil)
            {
                self.vcChat.Add_Update_Item()
            }
            else
            {
                self.vcChat.needsReload = true
            }
        }
    }
    
    
    // MARK: - methods for use by all View Controllers
    
    /// Called by the ViewController that holds the device list, after the user has selected (tapped) a device from the list
    ///
    /// - Parameters:
    ///     - peripheral: The selected device
    ///
    public func DidSelectDevice(peripheral: CBPeripheral)
    {
        BLEConroller.shared.connectToDevice(peripheral: peripheral)
    }

    
    /// Called by the ViewController that holds the device list, after the user took action to disconnect a device
    ///
    /// - Parameters:
    ///     - peripheral: The device to disconnect
    ///
    public func didTriggerDisconnect(peripheral: CBPeripheral)
    {
        BLEConroller.shared.disconnectFromDevice(peripheral: peripheral)
        self.masterDataProcessor.resetDB()
    }
    
    
    /// Called by the ViewController that holds the device list, after the user took action to refresh the list
    ///
    public func didTriggerRefreshDeviceList()
    {
        BLEConroller.shared.rescanForDevices()
    }
    
    
    public func didTriggerSendMessage(message: String, toUserID: String)
    {
        BLEConroller.shared.sendMessage(message: message, toUserID: toUserID)
    }
    
    
    /// Called by tvcConfig after the user has changed a radio-config value
    ///
    /// - Parameters:
    ///     - dataFieldName: The name of the datafield whose name was changed
    ///     - value: The new Value of the datafield
    ///     - currentRaidioConfig: The config data to be updated
    ///
    public func radioConfigValueUpdated(dataFieldName: String, value: String, currentRaidioConfig: RadioConfig_DO)
    {
        masterDataProcessor.radioConfig_setValue(dataFieldName: dataFieldName, value: value, currentRaidioConfig: currentRaidioConfig)
    }

    
    /// Called by tvcConfig after the user has changed the LoRa modulation config, that consists of 3 values
    ///
    /// - Parameters:
    ///     - dataFieldName: The name of the datafield whose name was changed
    ///     - value: The new Value of the datafield
    ///
    public func radioConfigLoRaModulationUpdated(bandwidth: String, spreadingFactor: String, codingRate: String, currentRadioConfig: RadioConfig_DO)
    {
        masterDataProcessor.radioConfig_setLoRaModulation(bandwidth: bandwidth, spreadingFactor: spreadingFactor, codingRate: codingRate, currentRadioConfig: currentRadioConfig)
    }

    
    /// Called by vcMyUserConfig after the user has touched the save bnutton
    ///
    /// - Parameters:
    ///     - user_DO: The user data object containig the updated data
    ///
    public func myUserConfigUpdated(user_DO: User_DO)
    {
        masterDataProcessor.setOwner(myUser_DO: user_DO)
    }
    
    //---------------------------------------------------------------------------------------

    
    // MARK: - Initialization
    private init()
    {
        tvcBLEDevices = Meshtastic.tvcBLEDevices()
        dialogMessage = UIAlertController()
        masterDataProcessor = MasterDataProcessor()
    }
    
    
    
    
    
}


