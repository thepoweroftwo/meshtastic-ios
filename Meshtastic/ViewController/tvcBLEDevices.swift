//
//  tvcBLEDevices.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 20.09.20.
//

import UIKit
import CoreBluetooth


class tvcBLEDevices: UITableViewController
{
    //---------------------------------------------------------------------------------------
    // MARK: - IBOutlets
    //---------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------

        
    //---------------------------------------------------------------------------------------
    // MARK: - IBActions
    //---------------------------------------------------------------------------------------

    // Pull to refresh action
    @IBAction func RefreshControlValueChanged(_ sender: Any)
    {
        // Clear data array and refill it
        dataChangedHandler(nil)
        tableView.reloadData()
        MasterViewController.shared.didTriggerRefreshDeviceList()
        (sender as AnyObject).endRefreshing()
    }
        
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - private class variables
    //---------------------------------------------------------------------------------------

    private var centralManager: CBCentralManager!
    private var peripheralArray = [CBPeripheral]()
    private var tableDataArray = [tableDataObject]()
    
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public class variables
    //---------------------------------------------------------------------------------------

    struct tableDataObject
    {
        private var _peripheral: CBPeripheral!
        var deviceName: String?
        var state: String?
        var isConnected: Bool?
        var peripheral: CBPeripheral
        {
            set(newPeripheral)
            {
                _peripheral = newPeripheral
                deviceName = newPeripheral.name
                switch newPeripheral.state
                {
                case .connected:
                    state = "connected"
                    isConnected = true
                case .disconnected:
                    state = "disconnected"
                    isConnected = false
                case .connecting:
                    state = "connecting"
                    isConnected = false
                case .disconnecting:
                    state = "disconnecting"
                    isConnected = false
                @unknown default:
                    state = "disconnected"
                    isConnected = false
                    break
                }
            }
            
            get
            {
                return _peripheral
            }
        }
    }

    //---------------------------------------------------------------------------------------
    
        
    //---------------------------------------------------------------------------------------
    // MARK: - private functions
    //---------------------------------------------------------------------------------------

    /// Handler for the table data object
    ///
    /// - Parameters:
    ///     - peripheral: (optional) The peripheral object to handel
    ///
    func dataChangedHandler(_ peripheral: CBPeripheral!)
    {
        var iCounter = 0
        
        // If no devices were found, we can call the function without a parameter.
        // Here we insert one special item into tableDataArray to tell the user
        if (peripheral == nil)
        {
            var tmpTableDataObject = tableDataObject()
            tableDataArray.removeAll()
            if(BLEConroller.shared.isBLEConnected)
            {
                addConnectedDevice()
            }
            else
            {
                tmpTableDataObject.deviceName = "No devices found"
                tmpTableDataObject.isConnected = false
                tableDataArray += [tmpTableDataObject]
            }
            return
        }
        
        // Check if device is already in the array. If true, update the data
        for element in tableDataArray
        {
            if (element.deviceName == peripheral.name)
            {
                tableDataArray[iCounter].peripheral = peripheral
                iCounter = -1
                break
            }
            iCounter += 1
        }
        
        // If device isn't already in array, add it
        if (iCounter != -1)
        {
            if (tableDataArray[0].deviceName == "No devices found")
            {
                tableDataArray.removeAll()
            }
            
            var tmpTableDataObject = tableDataObject()
            tmpTableDataObject.peripheral = peripheral
            tableDataArray += [tmpTableDataObject]
            addConnectedDevice()
        }
    }
    
    
    /// Handler for the connected device
    /// Due to the fact that connected devices don't send BLE advertisement data
    /// we need to manually handle it here
    ///
    func addConnectedDevice()
    {
        // Check if there is a connected device
        if(BLEConroller.shared.isBLEConnected)
        {
            for element in tableDataArray
            {
                if (element.deviceName == BLEConroller.shared.connectedDevice.name)
                {
                    // If the table allready contains the connected device there is nothing to do
                    return
                }
            }
            // If the table doesn't contain the connected device we have to add it
            var tmpTableDataObject = tableDataObject()
            tmpTableDataObject.peripheral = BLEConroller.shared.connectedDevice
            self.tableDataArray += [tmpTableDataObject]
        }
    }
    
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public functions
    //---------------------------------------------------------------------------------------

    /// Adds a new item to table or updates an existing.
    /// It's called by BLEController using the MasterViewController
    ///
    /// - Parameters:
    ///     - peripheral: The peripheral object to add or update
    ///
    public func Add_Update_Item(_ peripheral: CBPeripheral!)
    {
        dataChangedHandler(peripheral)
        self.tableView.reloadData()
    }
    
    //---------------------------------------------------------------------------------------

    
    //=======================================================================================
    // MARK: - TableView delegates
    //=======================================================================================

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = "Connect"
        
        dataChangedHandler(nil)
        
        MasterViewController.shared.tvcBLEDevices = self
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        MasterViewController.shared.currentViewController = self
    }

    
    // Customized swipe-button in cells to disconnect from device
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: nil)
        { (_, _, completionHandler) in
            // disconnect
            MasterViewController.shared.didTriggerDisconnect(peripheral: self.tableDataArray[indexPath.row].peripheral)
            completionHandler(true)
        }
        //deleteAction.image = UIImage(systemName: "trash")
        deleteAction.title = "disconnect"
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    // Create a standard header that includes the returned text.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Nearby devices"
    }
    
    
        
    //---------------------------------------------------------------------------------------
    // Table datasource
    //---------------------------------------------------------------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableDataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tableDataArray[indexPath.row].deviceName
                
        if (tableDataArray[indexPath.row].isConnected!)
        {
            cell.detailTextLabel?.textColor = UIColor.systemGreen
        }
        else
        {
            cell.detailTextLabel?.textColor = UIColor.label
        }
        cell.detailTextLabel?.text = tableDataArray[indexPath.row].state
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (tableDataArray[indexPath.row].deviceName == "No devices found")
        {
            return
        }
        
        if (BLEConroller.shared.isBLEConnected)
        {
            if (tableDataArray[indexPath.row].peripheral == BLEConroller.shared.connectedDevice)
            {
                //performSegue(withIdentifier: "SegueShowDeviceDetails", sender: nil)
                
                MasterViewController.shared.show_tbcDeviceDetails()
                
                return
            }
            else
            {
                // Create new Alert
                let dialogMessage = UIAlertController(title: "Info", message: "Cannot connect to Meshtasic device because another connection was already established", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
                return
            }
        }
        
        MasterViewController.shared.DidSelectDevice(peripheral: tableDataArray[indexPath.row].peripheral)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //---------------------------------------------------------------------------------------

            
    //---------------------------------------------------------------------------------------
    // Navigation
    //---------------------------------------------------------------------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if  (segue.identifier == "SegueShowDeviceDetails")
        {
//            let destination = segue.destination as? tbcDeviceDetails
//            destination?.connectedDevice = self.connectedDevice
        }
    }
    
    //---------------------------------------------------------------------------------------

    
    //=======================================================================================
    // END TableView delegates
    //=======================================================================================
    
}
