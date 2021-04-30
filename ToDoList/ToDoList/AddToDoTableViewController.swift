//
//  AddToDoTableViewController.swift
//  ToDoList
//
//  Created by Admin1 on 10/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

class AddToDoTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date.addTimeInterval(24*60*60)
        updateData()
        saveButtonState()
        updateDateLabel(date: datePicker.date)
        
    }
    
    // MARK: - Model
    var todo: ToDo?
    var isPickerHidden = true
    
    // MARK: - Outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var isCompletedButton: UIButton!
    @IBOutlet weak var remindMeTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    
    func saveButtonState(){
        let remindMeText = remindMeTextField.text ?? ""
        saveButton.isEnabled = !remindMeText.isEmpty
    }
    
    func updateDateLabel(date: Date){
        dateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        saveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        remindMeTextField.resignFirstResponder()
    }
    
    @IBAction func isCompletedButtonTapped(_ sender: UIButton) {
        isCompletedButton.isSelected = !isCompletedButton.isSelected
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateLabel(date: datePicker.date)
    }
    
    func updateData(){
        if let todo = todo{
            navigationItem.title = "To-Do"
            remindMeTextField.text = todo.title
            isCompletedButton.isSelected = todo.isComplete
            datePicker.date = todo.dueDate
            textView.text = todo.notes
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else if section == 2{
            return 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let expandedCell = CGFloat(200)
        let cellIndexPath = IndexPath(row: 0, section: 1)
        let notesCellIndexPath = IndexPath(row: 0, section: 2)
        
        switch indexPath {
        case cellIndexPath:
            return isPickerHidden ? normalCellHeight : expandedCell
        case notesCellIndexPath:
            return expandedCell
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let dueDateCellIndexPath = IndexPath(row: 0, section: 1)
        switch indexPath {
        case dueDateCellIndexPath:
            isPickerHidden = !isPickerHidden
            dateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let remindText = remindMeTextField.text!
        let isComplete = isCompletedButton.isSelected
        let date = datePicker.date
        let notes = textView.text
        
        todo = ToDo(title: remindText, isComplete: isComplete, dueDate: date, notes: notes)
        
        
    }


}
