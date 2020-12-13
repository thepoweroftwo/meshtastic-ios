//
//  NodeInfo_DP.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 13.12.20.
//

import Foundation


/// NodeInfo data processor
///
class NodeInfo_DP
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
    
    /// Writes a node object into database
    /// If the object allready exists in db it will be updated
    ///
    /// - Parameters:
    ///     - nodeInfo: The node data object
    ///
    public func dbWrite(nodeInfo: NodeInfo_DO)
    {
        
        
    }
    
    /// Updates a person object within it's node structure.
    /// If the appropriate node object doesn't allready exist in database, we create it
    ///
    /// - Parameters:
    ///     - user: The user data object
    ///     - nodeId: Id of the enclosing node object
    ///
    public func dbWrite(user: User_DO, nodeId: UInt32)
    {
        
        
    }

    
    /// Updates a position object within it's node structure.
    /// If the appropriate node object doesn't allready exist in database, we create it
    ///
    /// - Parameters:
    ///     - position: The position data object
    ///     - nodeId: Id of the enclosing node object
    ///
    public func dbWrite(position: Position_DO, nodeId: UInt32)
    {
        
        
    }

    //---------------------------------------------------------------------------------------

    
}
