//
//  vcChat.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 07.02.21.
//

import UIKit

class vcChat: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{

    //---------------------------------------------------------------------------------------
    // MARK: - IBOutlets
    //---------------------------------------------------------------------------------------

    @IBOutlet var tableView: UITableView!
    @IBOutlet var txtTextInput: UITextView!
    @IBOutlet var svInput: UIStackView!
    
    //---------------------------------------------------------------------------------------
    
    
    //---------------------------------------------------------------------------------------
    // MARK: - IBActioons
    //---------------------------------------------------------------------------------------

    @IBAction func btnSend_TouchUp(_ sender: Any)
    {
        MasterViewController.shared.didTriggerSendMessage(message: txtTextInput.text!, toUserID: self.selectedUserId)
        txtTextInput.text = ""
    }
    
    //---------------------------------------------------------------------------------------
    
    
    //---------------------------------------------------------------------------------------
    // MARK: - private class variables
    //---------------------------------------------------------------------------------------

    private var chatMessage_DP = ChatMessage_DP()
    private var nodeInfo_DP = NodeInfo_DP()
    private var conversationArray = [ChatMessage_DO]()
    
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

    //---------------------------------------------------------------------------------------

    
    //=======================================================================================
    // MARK: - UIView delegates
    //=======================================================================================

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        self.txtTextInput.delegate = self
        
        self.conversationArray = self.chatMessage_DP.getConversation(self.selectedUserId)
        MasterViewController.shared.vcChat = self
        
        // Set constraint to move content up when keyboard appears
        self.svInput.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true

        // Set adaptive row height
        tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = 44
        
        // Set placeholder text
        txtTextInput.text = "Message"
        txtTextInput.textColor = UIColor.systemGray
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
    // END UIView delegates
    //=======================================================================================


    
    
    //=======================================================================================
    // MARK: - TableView delegates
    //=======================================================================================

    
    //---------------------------------------------------------------------------------------
    // Table datasource
    //---------------------------------------------------------------------------------------

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.conversationArray.count
    }


    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        cell.textLabel?.text = self.conversationArray[indexPath.row].messagePayload
        cell.detailTextLabel?.text = self.conversationArray[indexPath.row].fromUserLongName
        
        // Set text color ....
        if (self.conversationArray[indexPath.row].direction == "IN")
        {
            // .... for incomming messages
            cell.textLabel?.textColor = UIColor.systemOrange
        }
        else if (self.conversationArray[indexPath.row].direction == "OUT")
        {
            // .... for outgoing messages
            cell.textLabel?.textColor = UIColor.systemGreen
        }
        
        return cell
    }

        
    //=======================================================================================
    // END TableView delegates
    //=======================================================================================

    
    
    
    //=======================================================================================
    // MARK: - TextView delegates
    //=======================================================================================

    
    //---------------------------------------------------------------------------------------
    // Handle placeholder text
    //---------------------------------------------------------------------------------------
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.systemGray
        {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = "Placeholder"
            textView.textColor = UIColor.systemGray
        }
    }
    
    
    
    
    //=======================================================================================
    // END TextView delegates
    //=======================================================================================

}
