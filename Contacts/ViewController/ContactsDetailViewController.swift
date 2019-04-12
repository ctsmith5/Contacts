//
//  ContactsDetailViewController.swift
//  Contacts
//
//  Created by Colin Smith on 4/12/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class ContactsDetailViewController: UIViewController, UITextFieldDelegate {

    
    var contact: Contact?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = contact?.name
        phoneTextField.text = contact?.phone
        emailTextField.text = contact?.email
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.text = contact?.name
        phoneTextField.text = contact?.phone
        emailTextField.text = contact?.email
    }
   
    
    @IBAction func saveContactButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let contact = contact else {return}
        
        let name = contact.name
        guard let email = contact.email,
            let phone = contact.phone else {return}
        ContactController.shared.save(name: name, email: email, phone: phone) { (contact) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    
}
