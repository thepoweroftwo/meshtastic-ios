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
    var dialogMessage: UIAlertController
    var currentViewController: UIViewController!
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
    
    
    public func DebugPrint2View(text: String)
    {
        self.tbcDeviceDetails.DebugPrint2View(text: text)
    }

    
    // MARK: - methods for use by BLEController

    /// Called by MasterDataProcessor after data has been updated by device
    ///
    /// - Parameters:
    ///     - radioConfig: the dataobject that holds the updated data
    ///
    public func updateFromDevice(radioConfig: RadioConfig_DO)
    {
        self.tbcDeviceDetails.refreshRadioConfigData(radioConfig: radioConfig)
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
    public func DidTriggerDisconnect(peripheral: CBPeripheral)
    {
        BLEConroller.shared.disconnectFromDevice(peripheral: peripheral)
    }
    
    
    /// Called by the ViewController that holds the device list, after the user took action to refresh the list
    ///
    public func DidTriggerRefreshDeviceList()
    {
        BLEConroller.shared.rescanForDevices()
    }
    
    
    public func didTriggerSendMessage(message: String)
    {
        BLEConroller.shared.sendMessage(message: message)            
    }
        
    
    //---------------------------------------------------------------------------------------

    
    // MARK: - Initialization
    private init()
    {
        tvcBLEDevices = Meshtastic.tvcBLEDevices()
        dialogMessage = UIAlertController()
    }
    
    
    
    
    
}


