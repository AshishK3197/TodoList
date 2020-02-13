//
//  SavedReminderViewController.swift
//  TodoList
//
//  Created by Ashish Kumar on 27/01/20.
//  Copyright © 2020 Ashish Kumar. All rights reserved.
//

import UIKit
import Firebase

class SavedReminderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemArray = [TodoItem]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
 
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var emptyTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "Add new Item to the list", preferredStyle: .alert)
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Enter new Item"
            emptyTextField = addTextField
            
        }
        
        let action = UIAlertAction(title: "Add It!!!", style: .default) { (action) in
            
           //Adding Data to firestore when tapping action on alert-->
            
            if let itemToBeAddedTextField = emptyTextField.text , let currentUser = Auth.auth().currentUser?.email {
                let docRef = self.db.collection("TodoItem").document()
                docRef.setData(["docId":docRef.documentID , "item":itemToBeAddedTextField, "user":currentUser]) { (error) in
                    if error != nil{
                        print("Data could not be Saved")
                    }else{
                        print("Data saved Successfully")
                    }
                }
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Loading Todo's from FireBase FirfeStore Before View Loads Up.
    func getData(){
        let currentUser = Auth.auth().currentUser?.email
        db.collection("TodoItem").whereField("user", isEqualTo: currentUser!).addSnapshotListener { (querySnapShot, error) in
            if error != nil{
                print("There was an error retrieving data from the firestore")
            }else{
                self.itemArray = []
                if let snapShotDocuments = querySnapShot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        
                        if let itemToBeAddedTextField = data["item"] as? String , let currentUser = Auth.auth().currentUser?.email{
                            let newItem = TodoItem(item: itemToBeAddedTextField, user: currentUser)
                            self.itemArray.append(newItem)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
}

//MARK: - TableView Methods
extension SavedReminderViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
//MARK: - Updating a particular data Field
        
        var textFieldToUpdate = UITextField()
            
            let alert = UIAlertController(title: "Update an Item?", message: "Update item to list", preferredStyle: .alert)
            alert.addTextField { (addTextField) in
                addTextField.placeholder = "Enter item to update"
                textFieldToUpdate = addTextField
                
            }
            
            let action = UIAlertAction(title: "Update It!!!", style: .default) { (action) in
                
               //Adding Data to firestore when tapping action on alert-->
                
                if let itemToBeUpdatedTextField = textFieldToUpdate.text {
                    let itemInRowToBeUpdated = self.itemArray[indexPath.row].item
                    let docRef = self.db.collection("TodoItem").whereField("item", isEqualTo: itemInRowToBeUpdated)
                    docRef.getDocuments { (querySnapShot, error) in
                        if let err = error{
                            print(err)
                        }else{
                            if let document = querySnapShot?.documents.first{
                                document.reference.updateData(["item":itemToBeUpdatedTextField]) { (error) in
                                    if error != nil{
                                        print("Data could not be updated")
                                    }else{
                                        print("Data updated Successfull")
                                    }
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)

        
    }
    
//MARK:- Deleting a Particular Datafield
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let itemToDelete = itemArray[indexPath.row].item
            db.collection("TodoItem").whereField("item", isEqualTo: itemToDelete).getDocuments { (querySnapShot, Error) in
                if Error != nil{
                    print("Data could not be Deleted")
                }else{
                    if let document = querySnapShot?.documents.first{
                        document.reference.delete() { (err) in
                            print("delete was successfull")
                        }
                    }
                }
            }
        }
    }
    
}



