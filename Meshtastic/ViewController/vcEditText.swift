//
//  vcEditText.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 01.11.20.
//

import UIKit


class vcEditText: UIViewController
{

    @IBOutlet var lblCaption: UILabel!
    @IBOutlet var txtValue: UITextField!    
    @IBOutlet var lblInfo: UILabel!
    
    
    @IBAction func btnCancel_TouchUp(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSave_TouchUp(_ sender: Any)
    {
        self.CellData.value = self.txtValue.text!
    }
    
    public struct cellData
    {
        var caption = ""
        var value = ""
        var info = ""
        var dataFieldName = ""
    }
    
    public var CellData = cellData(caption:"",value:"",info:"")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblCaption.text = self.CellData.caption
        txtValue.text = self.CellData.value
        lblInfo.text = self.CellData.info
        lblInfo.sizeToFit()

        // Do any additional setup after loading the view.
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
