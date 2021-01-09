//
//  vcMyUserConfig.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 08.01.21.
//

import UIKit

class vcMyUserConfig: UIViewController
{
    //---------------------------------------------------------------------------------------
    // MARK: - private class variables
    //---------------------------------------------------------------------------------------

    private var nodeInfo_DP: NodeInfo_DP = NodeInfo_DP()

    //---------------------------------------------------------------------------------------

    
    
    //---------------------------------------------------------------------------------------
    // MARK: - public class variables
    //---------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - ui variables and functions
    //---------------------------------------------------------------------------------------

    @IBOutlet var txtID: UITextField!
    @IBOutlet var txtShortName: UITextField!
    @IBOutlet var txtLongName: UITextField!
    @IBOutlet var txtCallsign: UITextField!
    @IBOutlet var txtCallsignCode: UITextField!
    @IBOutlet var txtMacAddress: UITextField!
    
    
    @IBAction func btnCancel_TouchUp(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSave_TouchUp(_ sender: Any)
    {
        let myUser: User_DO = User_DO()
        myUser.id = self.txtID.text!
        myUser.shortName = self.txtShortName.text!
        myUser.longName = self.txtLongName.text!
        myUser.macaddr = self.txtMacAddress.text!.hexadecimal ?? Data("".utf8)
        MasterViewController.shared.myUserConfigUpdated(user_DO: myUser)
        self.dismiss(animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - private functions
    //---------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public functions
    //---------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------

    
    //=======================================================================================
    // MARK: - View delegates
    //=======================================================================================

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        let myNode: NodeInfo_DO = nodeInfo_DP.getMyNodeObject()!
        
        self.txtID.text = myNode.user.id
        self.txtShortName.text = myNode.user.shortName
        self.txtLongName.text = myNode.user.longName
        self.txtMacAddress.text = myNode.user.macaddr.hexDescription
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //=======================================================================================
    // END View delegates
    //=======================================================================================

}
