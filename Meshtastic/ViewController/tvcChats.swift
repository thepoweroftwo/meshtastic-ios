//
//  tvcChats.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 27.12.20.
//

import UIKit

class tvcChats: UITableViewController
{
    
    
    //---------------------------------------------------------------------------------------
    // MARK: - private class variables
    //---------------------------------------------------------------------------------------
    
    private var user_DP = User_DP()
    private var chatUsersArray = [User_DO]()
    
    
    //---------------------------------------------------------------------------------------

        
    //---------------------------------------------------------------------------------------
    // MARK: - public class variables
    //---------------------------------------------------------------------------------------

    public var needsReload: Bool = false

    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - private functions
    //---------------------------------------------------------------------------------------
    
    @objc private func showMyUserConfig()
    {
        self.performSegue(withIdentifier: "SegueShowMyUserConfig", sender: self)
    }
    
    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public functions
    //---------------------------------------------------------------------------------------
    
    /// Adds a new item to table or updates an existing.
    /// It's called by MasterDataProcessor
    ///
    public func Add_Update_Item()
    {
        self.chatUsersArray = self.user_DP.getChatUsers()
        self.tableView.reloadData()
        self.needsReload = false
    }
    //---------------------------------------------------------------------------------------

    
    
    
    //=======================================================================================
    // MARK: - TableView delegates
    //=======================================================================================

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.chatUsersArray = self.user_DP.getChatUsers()
        MasterViewController.shared.tvcChats = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.visibleViewController?.title = "Chats"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(showMyUserConfig))

        if (self.needsReload)
        {
            self.chatUsersArray = self.user_DP.getChatUsers()
            self.tableView.reloadData()
        }
    }

    
    override func viewDidDisappear(_ animated: Bool)
    {
        if (self.tabBarController?.selectedIndex != 1)
        {
            self.tabBarController?.navigationItem.rightBarButtonItem = nil
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
        return self.chatUsersArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = self.chatUsersArray[indexPath.row].longName
        cell.detailTextLabel?.text = self.chatUsersArray[indexPath.row].shortName
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

    
    /*
     //---------------------------------------------------------------------------------------
     // Navigation
     //---------------------------------------------------------------------------------------

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //---------------------------------------------------------------------------------------


    //=======================================================================================
    // END TableView delegates
    //=======================================================================================

}
