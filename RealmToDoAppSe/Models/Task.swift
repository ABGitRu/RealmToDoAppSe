//
//  Task.swift
//  RealmToDoAppSe
//
//  Created by Mac on 13.05.2021.
// 
//


import RealmSwift

class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}

class TaskList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    var tasks = List<Task>()
}
