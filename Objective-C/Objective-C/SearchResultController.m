//
//  SearchResultController.m
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "SearchResultController.h"

NSString *const kCellIdentifier = @"TableViewCell";

@interface SearchResultController ()

@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

- (void)setFilteredData:(NSArray *)filteredData{
    _filteredData = filteredData;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    NSManagedObject *item = self.filteredData[indexPath.row];
    
    cell.textLabel.text = [item valueForKey:@"name"];
    
    return cell;
}

@end
