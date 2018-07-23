//
//  ViewController.swift
//  GenericTableView
//
//  Created by Viral Chauhan on 02/07/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//
import UIKit

class BaseCell<U> : UITableViewCell {
    var item: U!
}

class BaseTableViewController<T: BaseCell<U>, U> : UITableViewController {
    
    let cellIdentifier = "cellId"
    var item = [U]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(T.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! T
        cell.item = item[indexPath.row]
        return cell
    }
    
}


struct Person {
    let firstname: String
    let lastname: String
}


class PersonCell: BaseCell<Person> {
    override var item: Person! {
        didSet {
            textLabel?.text = item.firstname + " " + item.lastname
        }
    }
}


class PersonTableView : BaseTableViewController<PersonCell, Person> {
    override func viewDidLoad() {
        super.viewDidLoad()
        item = [
            Person(firstname: "Bob", lastname: "Johnson"),
            Person(firstname: "John", lastname: "mask")
        ]
    }
}
