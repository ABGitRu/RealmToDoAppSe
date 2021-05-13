//
//  StorageManager.swift
//  RealmToDoAppSe
//
//  Created by Mac on 13.05.2021.
//  
//


import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    func save(taskList: TaskList) {
        write {
            realm.add(taskList)
        }
    }
    
    func save(task: Task, into taskList: TaskList) {
        write {
            taskList.tasks.append(task)
        }
    }
    
    func delete(taskList: TaskList) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }
    
    func delete(task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func edit(taskList: TaskList, newValue: String) {
        write {
            taskList.name = newValue
        }
    }
    
    func edit(task: Task, name: String, note: String) {
        write {
            task.name = name
            task.note = note
        }
    }
    
    func done(taskList: TaskList) {
        taskList.tasks.setValue(true, forKey: "isCopmlete")
    }
    
    func done(task: Task) {
        write {
            task.isComplete.toggle()
        }
    }
    
    private func write(_ complition: () -> Void) {
        
        do {
            try realm.write {
                complition()
            }
        } catch let error {
            print(error)
        }
    }
}
