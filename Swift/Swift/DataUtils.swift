//
//  DataUtils.swift
//  Swift
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
    
    class var getInstance: DataUtils{
        struct Static {
            static var instance: DataUtils? = nil
            static var token: dispatch_once_t = 0
            
            dispatch_once(&Static.token) {
                Static.instance = DataUtils()
            }
            return Static.instance!

        }
    }
    
    class var installDatabase(name: String!)->void {
        struct Static {
            let instance: DataUtils = DataUtils.getInstance()
    
            if (instance.managedObjectModel == nil){
            
            }
        }
    }
    
    override init() {
        super.init()
    }
}
