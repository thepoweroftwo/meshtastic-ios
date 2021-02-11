//
//  ChatMessage_DP.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 02.02.21.
//

import Foundation

class ChatMessage_DP
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
    
    /// Get the index of a message within array
    ///
    /// - Parameters:
    ///     - chatMessage: The message object for which we want too get the index
    ///
    /// - Returns: The index of the message object within it's array
    ///
    private func getMessageIdx(_ messageId: UInt32) -> Int
    {
        var iCounter = 0
        for element in DataBase.shared.chatMessageArray
        {
            if (element.messageID == messageId)
            {
                return iCounter
            }
            iCounter += 1
        }
        return -1
    }

    //---------------------------------------------------------------------------------------

    
    //---------------------------------------------------------------------------------------
    // MARK: - public functions
    //---------------------------------------------------------------------------------------

    /// Writes a node object into database
    /// If the object allready exists in db it will be updated
    ///
    /// - Parameters:
    ///     - nodeInfo: The node data object
    ///
    public func dbWrite(_ chatMessage: ChatMessage_DO)
    {
        let index = getMessageIdx(chatMessage.messageID)
        if (index > -1) //Update
        {
            DataBase.shared.chatMessageArray[index] = chatMessage
        }
        else //Add
        {
            DataBase.shared.chatMessageArray += [chatMessage]
        }
    }

    
    /// Get all chat messages for a specified user
    ///
    /// - Parameters:
    ///     - userId: The id of the user for whom we need the chat data
    ///
    /// - Returns: An array containing all chat-message objects that belong to the conversation with the specified user
    ///
    public func getConversation(_ userId: String) -> [ChatMessage_DO]
    {
        var conversationArray = [ChatMessage_DO]()
        let user_DP = User_DP()
        let myUserId = user_DP.getMyUserId()
        
        if (userId == "BC")
        {
            for element in DataBase.shared.chatMessageArray
            {
                if (element.toUserID == "BC")
                {
                    if (element.fromUserID == myUserId)
                    {
                        element.direction = "OUT"
                    }
                    else
                    {
                        element.direction = "IN"
                    }
                    conversationArray += [element]
                }
            }
        }
        else
        {
            
        }
        
        return conversationArray.reversed()
    }
    
    
    //---------------------------------------------------------------------------------------

    
    
    
    
    
    
    
    
    
}
