//
//  TaskCell.swift
//  SwiftSource
//
//  Created by Nguyen Anh Minh on 2/23/16.
//  Copyright © 2016 Minh Nguyen. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: TaskCellDelegate?
    weak var task: Task?
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    internal enum ActionStyle: Int{
        case Add = 0
        case Delete = 1
    }
    
    func setContentData(data: Task){
        if (data.name == nil){
            self.inputTextField.text = ""
            self.inputTextField.borderStyle = UITextBorderStyle.RoundedRect
            
            self.addButton.setTitle("Add", forState: UIControlState.Normal)
            self.addButton.tag = ActionStyle.Add.rawValue
            self.addButton.enabled = false
        } else {
            self.inputTextField.text = data.name
            self.inputTextField.borderStyle = UITextBorderStyle.RoundedRect
            
            self.addButton.setTitle("Delete", forState: UIControlState.Normal)
            self.addButton.tag = ActionStyle.Delete.rawValue
            self.addButton.enabled = true
        }
        self.task = data
    }
    
    @IBAction func didTapAddButton(sender: UIButton) {
        if (self.delegate == nil){
            return
        }
        self.delegate?.taskCell(self, didTapButton: sender)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.borderStyle = UITextBorderStyle.RoundedRect
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if (self.addButton.tag == ActionStyle.Delete.rawValue){
            textField.borderStyle = UITextBorderStyle.None
            let text = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if (text == nil || text == self.task!.name){
                return
            }
            
            if (text!.isEmpty){
                textField.text = self.task!.name
            }
            if (self.delegate == nil){
                return
            }
            self.delegate?.taskCell(self, didEndEditing: textField)
        }
    }
    
    @IBAction func textFieldEditingChange(sender: UITextField) {
        let text = sender.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (self.addButton.tag == ActionStyle.Add.rawValue){
            self.addButton.enabled = text!.isEmpty == false
        }
    }
}

protocol TaskCellDelegate: class{
    func taskCell(cell: TaskCell, didTapButton sender:UIButton)
    func taskCell(cell: TaskCell, didEndEditing sender:UITextField)
}