//
//  DataUtils.swift
//  SwiftSource
//
//  Created by Nguyen Anh Minh on 2/22/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

import Foundation
import CoreData

class DataUtils: NSObject {
    
    private var managedObjectContext: NSManagedObjectContext?
    private var managedObjectModel: NSManagedObjectModel?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    class var getInstance: DataUtils {
        struct Static {
            static var token = 0
            static var instance: DataUtils? = nil
        }
        
        dispatch_once(&Static.token) { () -> Void in
            Static.instance = DataUtils()
        }
        
        return Static.instance!
    }
    
    class func installDatabase(name: String!) {
        let instance = DataUtils.getInstance
        if (instance.managedObjectModel == nil){
            
        }
        
        if (instance.persistentStoreCoordinator == nil){
            
        }
        
        if (instance.managedObjectContext == nil){
            
        }
    }
}
