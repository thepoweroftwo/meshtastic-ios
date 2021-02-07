//
//  vcChat.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 07.02.21.
//

import UIKit

class vcChat: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    //---------------------------------------------------------------------------------------
    // MARK: - IBOutlets
    //---------------------------------------------------------------------------------------

    @IBOutlet var tableView: UITableView!

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

    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        self.conversationArray = self.chatMessage_DP.getConversation(self.selectedUserId)
        MasterViewController.shared.vcChat = self
        
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
        return cell
    }

    
    
    
    
    
    
    
    //=======================================================================================
    // END TableView delegates
    //=======================================================================================

}
