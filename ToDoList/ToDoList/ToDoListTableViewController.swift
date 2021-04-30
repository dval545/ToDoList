//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Admin1 on 9/9/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController, ToDoCellDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedTodos = ToDo.loadTodos() {
            todos = savedTodos
        } else {
            todos = ToDo.loadSampleTodos()
        }
    }

    // MARK: - Model
    var todos = [ToDo]()
    
    // MARK: - Checkmark tapped
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender){
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveTodos(todos)
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return todos.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as?
            ToDoCell else {
                fatalError("Could not dequeue a cell")
        }
        let todo = todos[indexPath.row]
        cell.titleLabel.text = todo.title
        cell.completeButton.isSelected = todo.isComplete
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveTodos(todos)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            let addTodoViewController = segue.destination as! AddToDoTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            addTodoViewController.todo = todos[indexPath.row]
        }
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue){
        guard segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! AddToDoTableViewController
        
        if let todo = sourceViewController.todo{
            if let indexPath = tableView.indexPathForSelectedRow{
                todos[indexPath.row] = todo
                tableView.reloadRows(at: [indexPath], with: .none)
            } else{
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveTodos(todos)
    }
    
    
}
