//
//  Task.m
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import "Task.h"
#import <CoreData/CoreData.h>

@interface NSString (StringUtils)
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
@end

@implementation NSString (StringUtils)

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format{
    if (!date) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

@end

@implementation Task

+ (instancetype)taskWithManagedObject:(NSManagedObject *)object{
    Task *instance = [[Task alloc]init];
    
    if (instance) {
        instance.id = [object valueForKey:@"id"];
        instance.name = [object valueForKey:@"name"];
        instance.createDate = [object valueForKey:@"createDate"];
    }
    
    return instance;
}

- (NSDictionary *)dictionary{
    return @{
             @"id" : self.id,
             @"name" : self.name,
             @"createDate" : self.createDate
             };
}

@end
