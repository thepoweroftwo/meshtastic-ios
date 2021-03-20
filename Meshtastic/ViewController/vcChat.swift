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
    // MARK: - IBActions
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
    
    private func registerCell()
    {
        let cellMe = UINib(nibName: "cellChatMessageMe", bundle: nil)
        self.tableView.register(cellMe, forCellReuseIdentifier: "cellMessageMe")
        let cellUser = UINib(nibName: "cellChatMessageUser", bundle: nil)
        self.tableView.register(cellUser, forCellReuseIdentifier: "cellMessageUser")
        
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

    //---------------------------------------------------------------------------------------

    
    //=======================================================================================
    // MARK: - UIView delegates
    //=======================================================================================

    override func viewDidLoad()
    {
        super.viewDidLoad()
        registerCell()
        
        let yourColor : UIColor = UIColor( red: 0.4, green: 0.4, blue:0.4, alpha: 0.5 )
        txtTextInput.layer.masksToBounds = true
        txtTextInput.layer.borderColor = yourColor.cgColor
        txtTextInput.layer.borderWidth = 1.0
        txtTextInput.layer.cornerRadius = 15
        
        txtTextInput.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        self.txtTextInput.delegate = self
        
        self.conversationArray = self.chatMessage_DP.getConversation(self.selectedUserId)
        MasterViewController.shared.vcChat = self
        
        // Set constraint to move content up when keyboard appears
//        self.svInput.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10).isActive = true

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
        
        // Set text color ....
        if (self.conversationArray[indexPath.row].direction == "IN")
        {
            // .... for incomming messages
            let customCell = tableView.dequeueReusableCell(withIdentifier: "cellMessageUser", for: indexPath) as! cellChatMessageUser
            customCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

            customCell.messageText?.text = self.conversationArray[indexPath.row].messagePayload
            customCell.messageUser?.text = self.conversationArray[indexPath.row].fromUserLongName
            
            return customCell
        }
        else if (self.conversationArray[indexPath.row].direction == "OUT")
        {
            // .... for outgoing messages
            let customCell = tableView.dequeueReusableCell(withIdentifier: "cellMessageMe", for: indexPath) as! cellChatMessageMe
            customCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

            customCell.messageText?.text = self.conversationArray[indexPath.row].messagePayload
            customCell.messageUser?.text = self.conversationArray[indexPath.row].fromUserLongName
            
            return customCell
        }
        
        return UITableViewCell()
        
        
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
            textView.text = "Message"
            textView.textColor = UIColor.systemGray
        }
    }
    
    
    
    
    //=======================================================================================
    // END TextView delegates
    //=======================================================================================

}
