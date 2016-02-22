//
//  TableViewCell.h
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeAdd = 0,
    ActionTypeDelete
};

@class Task;

@protocol TableViewCellDelegate;

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) id<TableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (void)setContentData:(Task*)data;

@end

@protocol TableViewCellDelegate <NSObject>

- (void)cell:(TableViewCell*)cell didTapButton:(UIButton*)sender;
- (void)cell:(TableViewCell *)cell didEndEditTask:(UITextField*)sender;

@end