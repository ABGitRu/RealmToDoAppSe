//
//  TasksViewController.swift
//  RealmToDoAppSe
//
//  Created by Mac on 13.05.2021.
//  
//


import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    var currentList: TaskList!
    
    var currentTasks: Results<Task>!
    var completedTask: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentList.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        currentTasks = currentList.tasks.filter("isComplete = false")
        completedTask = currentList.tasks.filter("isComplete = true")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTask.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)

        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        
        return cell
    }
    
    // MARK: - Table view delegate
       
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0
            ? currentTasks[indexPath.row]
            : completedTask[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.shared.delete(task: task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, isDone) in
            self.showAlert(with: task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (_, _, isDone) in
            
            StorageManager.shared.done(task: task)
            
            let indexPathForCurrentTasks = IndexPath(row: self.currentTasks.count - 1, section: 0)
            let indexPathForCompletedTasks = IndexPath(row: self.completedTask .count - 1, section: 1)
            
            let destinationIndexRow = indexPath.section == 0
                ? indexPathForCompletedTasks
                : indexPathForCurrentTasks
            
            tableView.moveRow(at: indexPath, to: destinationIndexRow)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, deleteAction, editAction])
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }

}

extension TasksViewController {
    
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Update task" : "New Task"
        
        let alert = AlertController(title: title, message: "What do you want to do", preferredStyle: .alert)
        alert.action(with: task) { newValue, note in
            
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task: task, name: newValue, note: note)
                completion()
            } else {
                let task = Task(value: [newValue, note])
                StorageManager.shared.save(task: task, into: self.currentList)
                let rowIndex = IndexPath(row: self.currentTasks.count - 1, section: 0)
                self.tableView.insertRows(at: [rowIndex], with: .automatic)
            }
        }
        present(alert, animated: true)
    }
}
 
