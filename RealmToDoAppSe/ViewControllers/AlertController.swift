//
//  AlertController.swift
//  RealmToDoAppSe
//
//  Created by Mac on 13.05.2021.
//  
//


import UIKit

class AlertController: UIAlertController {
    
    var doneButton = "Save"
    
    func action(with taskList: TaskList?, complition: @escaping (String) -> Void) {
        
        if taskList != nil { doneButton = "Update" }
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            complition(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "Last Name"
            textField.text = taskList?.name
            
        }
    }
    
    func action(with task: Task?, complition: @escaping (String, String) -> Void) {
        
        if task != nil { doneButton = "Update"}
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newTask = self.textFields?.first?.text else { return }
            guard !newTask.isEmpty else { return }
            
            if let note = self.textFields?.last?.text, !note.isEmpty {
                complition(newTask, note)
            } else {
                complition(newTask, "")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "New Task"
            textField.text = task?.name
        }
        
        addTextField { textField in
            textField.placeholder = "Note"
            textField.text = task?.note
        }
    }
}

