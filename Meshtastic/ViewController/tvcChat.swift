//
//  tvcChat.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 03.02.21.
//

import UIKit

class tvcChat: UITableViewController
{
    
    @IBOutlet var writeView: UIView!
    
    //---------------------------------------------------------------------------------------
    // MARK: - private class variables
    //---------------------------------------------------------------------------------------

    private var chatMessage_DP = ChatMessage_DP()
    private var nodeInfo_DP = NodeInfo_DP()
    private var conversationArray = [ChatMessage_DO]()
    private let keyboardLayoutGuide =  UILayoutGuide()
    
    private let accessoryView = avChatTextInput(frame: CGRect.zero)

    //---------------------------------------------------------------------------------------

        
    //---------------------------------------------------------------------------------------
    // MARK: - public class variables
    //---------------------------------------------------------------------------------------
    
    public var selectedUserId: String = ""
    public var needsReload: Bool = false
    
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - private functions
    //---------------------------------------------------------------------------------------

    @objc func keyboardWillShow(notification: NSNotification)
    {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
        self.navigationController?.toolbar.frame.origin.y = self.view.frame.height - keyboardSize.height - (self.navigationController?.toolbar.frame.height)!
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      // move back the root view origin to zero
        self.navigationController?.toolbar.frame.origin.y = self.view.frame.height - keyboardSize.height - (self.navigationController?.toolbar.frame.height)!
    }

    
    @objc func keyboardWillChangeFrame(notification: NSNotification)
    {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      // move back the root view origin to zero
        self.navigationController?.toolbar.frame.origin.y = self.view.frame.height - keyboardSize.height - (self.navigationController?.toolbar.frame.height)!
    }

    
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public functions
    //---------------------------------------------------------------------------------------

    /// Adds a new item to table or updates an existing.
    /// It's called by MasterViewController
    ///
    public func Add_Update_Item()
    {
        self.conversationArray = self.chatMessage_DP.getConversation(self.selectedUserId)
        self.tableView.reloadData()
        self.needsReload = false
    }
    
    override var inputAccessoryView: avChatTextInput
    {
        return accessoryView
    }

//    override func canBecomeFirstResponder() -> Bool
//    {
//        return true
//    }

    //---------------------------------------------------------------------------------------

    
    
    //=======================================================================================
    // MARK: - TableView delegates
    //=======================================================================================

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //writeView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: writeView)
        self.toolbarItems = [progressButton]
        self.navigationController?.setToolbarHidden(false, animated: true)
                
        
//        self.navigationController?.toolbar.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -40).isActive = true
        
        //self.conversationArray = [ChatMessage_DO]()
        self.conversationArray = self.chatMessage_DP.getConversation(self.selectedUserId)
        MasterViewController.shared.tvcChat = self
        
        
        
//        // call the 'keyboardWillShow' function when the view controller receive notification that keyboard is going to be shown
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        
        
        
        
        
        
        
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        if (self.selectedUserId == "BC")
        {
            self.navigationController?.visibleViewController?.title = "Broadcast"
        }
        else
        {
            let nodeId = nodeInfo_DP.getNodeIdByUserId(userId: self.selectedUserId)
            let node = nodeInfo_DP.dbRead(nodeId: nodeId)
            self.navigationController?.visibleViewController?.title = node?.user.longName
        }
    
        if (self.needsReload)
        {
            Add_Update_Item()
        }
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
        return self.conversationArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = self.conversationArray[indexPath.row].messagePayload
        cell.detailTextLabel?.text = self.conversationArray[indexPath.row].fromUserLongName

        return cell
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
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //---------------------------------------------------------------------------------------
    
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
    }
    
    
    //=======================================================================================
    // END TableView delegates
    //=======================================================================================

}
