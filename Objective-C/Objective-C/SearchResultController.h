//
//  SearchResultController.h
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier;

@interface SearchResultController : UITableViewController

@property (nonatomic, strong) NSArray *filteredData;

@end
