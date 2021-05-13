//
//  Extension + UITableViewCell.swift
//  RealmToDoAppSe
//
//  Created by Mac on 13.05.2021.
//  
//


import UIKit

extension UITableViewCell {
    func configure(with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false")
        let completedTasks = taskList.tasks.filter("isComplete = true")
        
        textLabel?.text = taskList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            accessoryType = .none
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = nil
            accessoryType = .checkmark
        } else {
            detailTextLabel?.text = "0"
            accessoryType = .none
        }
    }
}
