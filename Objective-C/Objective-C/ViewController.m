//
//  ViewController.m
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import "Task.h"
#import "DataUtils.h"
#import "ViewController.h"
#import "TableViewCell.h"
#import "SearchResultController.h"

static NSString *const cellIdentifier = @"TableViewCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, TableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, weak) DataUtils *data;

@property (nonatomic, strong) SearchResultController *searchResultController;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResultController = [[SearchResultController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.searchResultController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self;
    
    self.data = [DataUtils getInstance];

    self.dataList = [NSMutableArray array];
    [self.dataList addObjectsFromArray:[self.data fetchEntityWithName:@"Task" withCondition:nil withSortCondition:nil withLimit:-1 withBindClass:@"Task"]];
    [self.dataList addObject:[Task new]];
    
    self.totalRow = self.dataList.count;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Result Updater
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    SearchResultController *searchResultController = (SearchResultController*)searchController.searchResultsController;
    
    NSPredicate *condition = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    searchResultController.filteredData = [self.data fetchEntityWithName:@"Task" withCondition:condition withSortCondition:nil withLimit:-1];
}

#pragma mark - UITableView's Data Source & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.totalRow;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Task *task = self.dataList[indexPath.row];
    
    cell.delegate = self;
    [cell setContentData:task];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Cell Delegate
- (void)cell:(TableViewCell *)cell didTapButton:(UIButton *)sender{
    switch (sender.tag) {
        case ActionTypeAdd:{
            Task *task = self.dataList.lastObject;
            task.name = cell.inputTextField.text;
            task.createDate = [NSDate date];
            task.id = [[NSProcessInfo processInfo] globallyUniqueString];
            if (![self.data updateEntity:@"Task" withCondition:nil withValue:[task dictionary]]) {
                return;
            }
            
            [self.dataList addObject:[Task new]];
            self.totalRow = self.dataList.count;
            [self.tableView reloadData];
        }
            break;
        case ActionTypeDelete:{
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (!indexPath) {
                return;
            }
            Task *task = self.dataList[indexPath.row];
            NSPredicate *condition = [NSPredicate predicateWithFormat:@"id == %@", task.id];
            if (![self.data deleteEntity:@"Task" withCondition:condition]) {
                return;
            }
            [self.dataList removeObject:task];
            self.totalRow = self.dataList.count;
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)cell:(TableViewCell *)cell didEndEditTask:(UITextField *)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    
    Task *task = self.dataList[indexPath.row];
    task.name = sender.text;
    
    NSPredicate *condition = [NSPredicate predicateWithFormat:@"id == %@", task.id];
    if (![self.data updateEntity:@"Task" withCondition:condition withValue:@{@"name":task.name}]) {
        return;
    }
    
}

@end
