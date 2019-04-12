//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Colin Smith on 4/12/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ContactController.shared.fetchContacts { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }

    //MARK: - Action
    @IBAction func addContactButtonTapped(_ sender: UIBarButtonItem) {
        presentAlert(name: "Add Contact" , message: "At least a name")
    }
    //MARK: - AlertController
    func presentAlert(name: String, message: String){
        let alertController = UIAlertController(title: name, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let postAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let nameText = alertController.textFields?[0].text else {return}
                  let phoneText = alertController.textFields?[1].text
                  let emailText = alertController.textFields?[2].text
            ContactController.shared.createContact(name: nameText, phone: phoneText, email: emailText, completion: { (contact) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        self.present(alertController, animated: true)
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"{
            let destinationVC = segue.destination as? ContactsDetailViewController
            guard let chosenCell = tableView.indexPathForSelectedRow else {return}
            let contact = ContactController.shared.contacts[chosenCell.row]
            destinationVC?.contact = contact
        }
       
    }
    

}
