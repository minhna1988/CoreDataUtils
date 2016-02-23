//
//  Task.swift
//  SwiftSource
//
//  Created by Nguyen Anh Minh on 2/23/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

import Foundation

class Task : NSObject{
    var id: String?
    var name: String?
    var createDate: NSDate?
    
    var dictionary: [String:AnyObject]{
        get{
            return ["id": id!, "name": name!, "createDate": createDate!]
        }
    }
}