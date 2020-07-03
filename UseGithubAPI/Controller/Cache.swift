//
//  Cache.swift
//  UseGithubAPI
//
//  Created by gem on 7/1/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import CoreData

class Cache {
    func save(arr:[GitRepo]){
        guard let appDel =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Repository", in: managedContext)!
        for arrRepo in arr {
            let repoDataCore = NSManagedObject(entity: entity, insertInto: managedContext)
            repoDataCore.setValue(arrRepo.login, forKey: "login")
            repoDataCore.setValue(arrRepo.commit, forKey: "commit")
            repoDataCore.setValue(arrRepo.avatar_url, forKey: "avatar_url")
            repoDataCore.setValue(arrRepo.name, forKey: "name")
            repoDataCore.setValue(arrRepo.star, forKey: "star")
            repoDataCore.setValue(arrRepo.watch, forKey: "watch")
            repoDataCore.setValue(arrRepo.fork, forKey: "fork")
            repoDataCore.setValue(arrRepo.issue, forKey: "issue")
            repoDataCore.setValue(arrRepo.priv, forKey: "priv")
        }
        do {
            try managedContext.save()
            print("Save User success")
        } catch {
            print("Could not save")
        }
    }
    func get() -> [GitRepo] {
        var arr = [GitRepo]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return arr }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Repository")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for i in result as! [NSManagedObject] {
                let loginName = i.value(forKey: "login") as! String
                let commit = i.value(forKey: "commit") as! String
                let imgAva = i.value(forKey: "avatar_url") as! String
                let repoName = i.value(forKey: "name") as! String
                let star = i.value(forKey: "star") as! String
                let watch = i.value(forKey: "watch") as! String
                let fork = i.value(forKey: "fork") as! String
                let issue = i.value(forKey: "issue") as! String
                let priv = i.value(forKey: "priv") as! String
                let repo = GitRepo.init(name: repoName, login: loginName, avatar_url: imgAva, star: star, watch: watch, fork: fork, issue: issue, commit: commit, url: "", priv: priv)
                arr.append(repo)
            }
        } catch {
            print("Could not fetch")
        }
        return arr
    }
    func delete(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSFetchRequestResult>(entityName: "Repository")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(fetchRequest)
            for object in result {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
            }
        } catch let error {
            print("error: \(error)")
        }
    }
}
