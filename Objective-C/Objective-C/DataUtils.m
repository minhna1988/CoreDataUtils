//
//  DataUtils.m
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "DataUtils.h"

@interface DataUtils()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataUtils

#pragma mark - Init Function

+ (instancetype)getInstance{
    
    static DataUtils *instance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[DataUtils alloc] init];
    });
    
    return instance;
}

+ (void)installDatabaseWithName:(NSString *)name{
    DataUtils *db = [DataUtils getInstance];
    
    if (!db.managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
        if (!modelURL) {
            NSLog(@"Couldn't locate model file");
            return;
        }
        db.managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    }
    
    if (!db.persistentStoreCoordinator) {
        db.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:db.managedObjectModel];
        NSURL *storeURL = [[db applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]];
        NSError *error = nil;
        [db.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
    }
    
    if (!db.managedObjectContext) {
        db.managedObjectContext = [[NSManagedObjectContext alloc]init];
        [db.managedObjectContext setPersistentStoreCoordinator:db.persistentStoreCoordinator];
    }
}

- (NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Common Function
- (NSArray*)fetchEntityWithName:(NSString *)name
                  withCondition:(NSPredicate *)condition
              withSortCondition:(NSArray*)sortConditions
                      withLimit:(NSInteger)limit{
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:name];
    fetchRequest.returnsObjectsAsFaults = NO;
    if (limit > 0) {
        [fetchRequest setFetchLimit:limit];
    }
    
    if (condition) {
        [fetchRequest setPredicate:condition];
    }
    if (sortConditions && sortConditions.count > 0) {
        [fetchRequest setSortDescriptors:sortConditions];
    }
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return error || !result ? @[] : result;
}

- (NSArray *)fetchEntityWithName:(NSString *)name withCondition:(NSPredicate *)condition withSortCondition:(NSArray *)sortConditions withLimit:(NSInteger)limit withBindClass:(NSString *)className{
    
    NSArray *objects = [self fetchEntityWithName:name withCondition:condition withSortCondition:sortConditions withLimit:limit];
    if (!className) {
        return objects;
    }
    NSMutableArray *conversion = [NSMutableArray array];
    [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *keys = [[[obj entity] attributesByName] allKeys];
        NSDictionary *dict = [obj dictionaryWithValuesForKeys:keys];
        
        NSObject *bind = [NSClassFromString(className) new];
        [bind setValuesForKeysWithDictionary:dict];
        
        [conversion addObject:bind];
        
    }];
    
    return conversion;
}

- (BOOL)updateEntity:(NSString*)name
       withCondition:(NSPredicate*)condition
           withValue:(NSDictionary*)values{
    
    NSManagedObject *entity = nil;
    if (condition) {
        NSArray *existingEntities = [self fetchEntityWithName:name withCondition:condition withSortCondition:nil withLimit:-1];
        entity = existingEntities.firstObject;
    }
    if (!entity) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
    }
    for (NSString* key in values.allKeys) {
        [entity setValue:values[key] forKey:key];
    }
    return [self save];
}

- (BOOL)deleteEntity:(NSString *)name withCondition:(NSPredicate *)condition{
    NSArray *result = [self fetchEntityWithName:name withCondition:condition withSortCondition:nil withLimit:-1];
    for (NSManagedObject *object in result){
        [self.managedObjectContext deleteObject:object];
    }
    return [self save];
}

- (BOOL)save{
    if (self.managedObjectContext) {
        NSError *error = nil;
        if ([self.managedObjectContext  hasChanges]) {
            [self.managedObjectContext save:&error];
        }
        return !error;
    }
    return NO;
}

@end
