//
//  DataUtils.h
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject

+ (instancetype)getInstance;

+ (void)installDatabaseWithName:(NSString *)name;

- (NSArray*)fetchEntityWithName:(NSString *)name
                  withCondition:(NSPredicate *)condition
              withSortCondition:(NSArray*)sortConditions
                      withLimit:(NSInteger)limit;

- (NSArray*)fetchEntityWithName:(NSString *)name
                  withCondition:(NSPredicate *)condition
              withSortCondition:(NSArray*)sortConditions
                      withLimit:(NSInteger)limit
                  withBindClass:(NSString*)className;

- (BOOL)updateEntity:(NSString*)name
       withCondition:(NSPredicate*)condition
           withValue:(NSDictionary*)values;

- (BOOL)deleteEntity:(NSString*)name withCondition:(NSPredicate *)condition;

@end
