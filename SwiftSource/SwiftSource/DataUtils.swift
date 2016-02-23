//
//  DataUtils.swift
//  SwiftSource
//
//  Created by Nguyen Anh Minh on 2/22/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

import Foundation
import CoreData

extension NSObject {
    
    class func fromClassName(className : String) -> NSObject {
        let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! NSObject.Type
        return aClass.init()
    }
    
}

class DataUtils: NSObject {
    
    private var managedObjectContext: NSManagedObjectContext?
    private var managedObjectModel: NSManagedObjectModel?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    // MARK: Setup func
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
            let modelURL = NSBundle.mainBundle().URLForResource(name, withExtension: "momd")
            if (modelURL == nil){
                return
            }
            instance.managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
        }
        
        if (instance.persistentStoreCoordinator == nil){
            instance.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: instance.managedObjectModel!)
            var storeURL = instance.applicationDocumentDirectory()
            if (storeURL == nil){
                return
            }
            storeURL = storeURL!.URLByAppendingPathComponent("\(name).sqlite")
            do {
                try instance.persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch _ as NSError{
                return
            }
        }
        
        if (instance.managedObjectContext == nil){
            instance.managedObjectContext = NSManagedObjectContext()
            instance.managedObjectContext!.persistentStoreCoordinator = instance.persistentStoreCoordinator
        }
    }
    
    func applicationDocumentDirectory()->NSURL?{
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
    }
    
    // MARK: Fetch Entity
    func fetchEntity(name: String!, condition: NSPredicate?, sortCondition: [NSSortDescriptor]?, limit: NSInteger)->[AnyObject]{
        let fetchRequest = NSFetchRequest(entityName: name)
        
        if (limit > 0){
            fetchRequest.fetchLimit = limit
        }
        
        if (condition != nil){
            fetchRequest.predicate = condition!
        }
        
        if (sortCondition != nil){
            fetchRequest.sortDescriptors = sortCondition!
        }
        
        var result = [AnyObject]()
        
        do {
            try result = self.managedObjectContext!.executeFetchRequest(fetchRequest)
        } catch _ as NSError{
            
        }
        return result
    }
    
    func fetchEntity(name: String!, condition: NSPredicate?, sortCondition: [NSSortDescriptor]?, limit: NSInteger, bind: String?)->[AnyObject]{
        var result = self.fetchEntity(name, condition: condition, sortCondition: sortCondition, limit: limit)
        
        if (bind != nil){
            let count = result.count - 1
            if (count == -1){
                return result
            }
            for i in 0...count{
                let object: NSManagedObject = result[i] as! NSManagedObject
                let instance = NSObject.fromClassName(bind!)
                let keys = Array(object.entity.attributesByName.keys)
                let dict = object.dictionaryWithValuesForKeys(keys)
                instance.setValuesForKeysWithDictionary(dict)
                result[i] = instance
            }
        }
        
        return result
    }
    
    // MARK: Update Entity
    func updateEntity(name: String!, condition: NSPredicate?, values: [String:AnyObject])->Bool{
        var entity: NSManagedObject? = nil
        
        if (condition != nil) {
            entity = self.fetchEntity(name, condition: condition, sortCondition: nil, limit: -1).last as? NSManagedObject
        }
        
        if (entity == nil){
            entity = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: self.managedObjectContext!)
        }
        
        entity!.setValuesForKeysWithDictionary(values)
        
        return self.save()
    }
    
    // MARK: Delete Entity
    func deleteEntity(name: String!, condition: NSPredicate?)->Bool{
        let existingObject = self.fetchEntity(name, condition: condition, sortCondition: nil, limit: -1)
        
        for object in existingObject{
            self.managedObjectContext?.deleteObject(object as! NSManagedObject)
        }
        
        return self.save()
    }
    
    // MARK: Save
    func save()->Bool{
        if (self.managedObjectContext != nil){
            do {
                try self.managedObjectContext!.save()
            } catch _ as NSError{
                return false
            }
        }
        return true
    }
    
}
