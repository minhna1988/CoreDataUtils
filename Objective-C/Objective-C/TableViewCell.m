//
//  TableViewCell.m
//  Objective-C
//
//  Created by Nguyen Anh Minh on 2/19/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

#import "Task.h"
#import "TableViewCell.h"

@interface TableViewCell()<UITextFieldDelegate>

@property (nonatomic, weak) Task *task;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentData:(Task *)data{
    if (data.name == nil) {
        self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self.addButton setTitle:@"Add" forState:UIControlStateNormal];
        self.addButton.tag = ActionTypeAdd;
        self.addButton.enabled = NO;
        self.inputTextField.text = @"";
    } else {
        self.inputTextField.borderStyle = UITextBorderStyleNone;
        [self.addButton setTitle:@"Delete" forState:UIControlStateNormal];
        self.addButton.tag = ActionTypeDelete;
        self.inputTextField.text = data.name;
    }
    self.task = data;
}

- (IBAction)didTapAddButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapButton:)]) {
        [self.delegate cell:self didTapButton:sender];
    }
}

#pragma mark - TextField's Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    NSString *text = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    switch (self.addButton.tag) {
        case ActionTypeAdd:{
            self.addButton.enabled = ![text isEqualToString:@""];
        }
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.borderStyle = UITextBorderStyleRoundedRect;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.addButton.tag == ActionTypeDelete) {
        textField.borderStyle = UITextBorderStyleNone;
        NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([text isEqualToString:self.task.name]) {
            return;
        }
        
        if ([text isEqualToString:@""]) {
            textField.text = self.task.name;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didEndEditTask:)]) {
            [self.delegate cell:self didEndEditTask:textField];
        }
    }
}

@end
