//
//  tabVcDebug.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 23.09.20.
//

import UIKit

class tabVcDebug: UIViewController
{

    var Test: String = ""

    @IBOutlet var txtView1: UITextView!
    
    
    @IBOutlet var txtMessage: UITextField!
    
    
    @IBAction func btnSend_TouchUp(_ sender: Any)
    {
        MasterViewController.shared.didTriggerSendMessage(message: txtMessage.text!)
        txtMessage.text = ""
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()

        // call the 'keyboardWillShow' function when the view controller receive notification that keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(tabVcDebug.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(tabVcDebug.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        if (!self.Test.isEmpty)
        {
            txtView1.text! += self.Test
            txtView1.scrollRangeToVisible(NSMakeRange(txtView1.text.count - 1, 1))
            self.Test.removeAll()

        }
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
