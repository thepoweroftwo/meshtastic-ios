//
//  User_DP.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 22.12.20.
//

import Foundation

class User_DP
{
    //---------------------------------------------------------------------------------------
    // MARK: - private class variables
    //---------------------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------------------

        
    //---------------------------------------------------------------------------------------
    // MARK: - public class variables
    //---------------------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------------------

    
    // MARK: - Initialization
    public init()
    {
        
        
    }
    
    
    //---------------------------------------------------------------------------------------
    // MARK: - private functions
    //---------------------------------------------------------------------------------------

    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public functions
    //---------------------------------------------------------------------------------------
    
    /// Get the id of your own user
    ///
    /// - Returns: A string with the user id or an empty string if the id was not found
    ///
    public func getMyUserId() -> String
    {
        let nodeInfo_DP = NodeInfo_DP()
        let myNodeNumber = DataBase.shared.myNodeInfo_DO.myNodeNum
        let myNodeObject = nodeInfo_DP.dbRead(nodeId: myNodeNumber)
        if (myNodeObject != nil)
        {
            return myNodeObject!.user.id
        }
        else
        {
            return ""
        }
    }
    
        
    /// Creates an array witth all users except your own.
    /// Use it to fill the Chat Users tableView
    ///
    /// - Returns: A chatUseres array
    ///
    public func getChatUsers() -> [User_DO]
    {
        var chatUsersArray = [User_DO]()
        let myUserId = getMyUserId()
        
        // create a user object for broadcasts
        let broadcastUser = User_DO()
        broadcastUser.id = "BC"
        broadcastUser.longName = "broadcast"
        broadcastUser.shortName = "bc"
        chatUsersArray += [broadcastUser]
        
        for element in DataBase.shared.nodeArray
        {
            if (element.user.id != myUserId)
            {
                chatUsersArray += [element.user]
            }
        }
        
        return chatUsersArray
    }

    
    //---------------------------------------------------------------------------------------

    
}
