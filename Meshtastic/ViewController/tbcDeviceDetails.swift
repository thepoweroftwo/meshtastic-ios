//
//  tbcDeviceDetails.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 22.09.20.
//

import UIKit
import CoreBluetooth


class tbcDeviceDetails: UITabBarController
{
    //---------------------------------------------------------------------------------------
    // MARK: - class variables and dataobjects
    //---------------------------------------------------------------------------------------
    var vcConfig: tvcConfig!
    var vcDebug: tabVcDebug!
    var vcChats: tvcChats!
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public functions
    //---------------------------------------------------------------------------------------
    /// For debugging only. Has to be removed later
    ///
    public func DebugPrint2View(text: String)
    {
        //self.selectedIndex = 2
        if (vcDebug.txtView1 != nil)
        {
            vcDebug.txtView1.text! += text
            vcDebug.txtView1.scrollRangeToVisible(NSMakeRange(vcDebug.txtView1.text.count - 1, 1))
        }
        else
        {
            vcDebug.Test += text
        }
    }

    
    /// Update config-table if device has sent new data
    ///
    public func refreshRadioConfigData(radioConfig: RadioConfig_DO)
    {
        vcConfig.radioConfig = radioConfig
        if (vcConfig.tableView != nil)
        {
            vcConfig.tableView.reloadData()
        }
        else
        {
            vcConfig.needsReload = true
        }
    }
    
    
    
    //---------------------------------------------------------------------------------------


    
    //=======================================================================================
    // MARK: - View delegates
    //=======================================================================================
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        vcDebug = (self.viewControllers![2] as? tabVcDebug)
        vcConfig = (self.viewControllers![0] as? tvcConfig)
        vcChats = (self.viewControllers![1] as? tvcChats)

        //print(self.viewControllers![0].title!)
        MasterViewController.shared.tbcDeviceDetails = self
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem

    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        MasterViewController.shared.currentViewController = self        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//=======================================================================================

