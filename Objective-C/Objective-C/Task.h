//
//  Task.h
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObject;

@interface Task : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *createDate;

+ (instancetype)taskWithManagedObject:(NSManagedObject*)object;

- (NSDictionary*)dictionary;

@end
