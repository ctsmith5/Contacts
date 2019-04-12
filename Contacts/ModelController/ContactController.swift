//
//  ContactController.swift
//  Contacts
//
//  Created by Colin Smith on 4/12/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    static let shared = ContactController()
    
    var contacts: [Contact] = []
    
    func createContact(name: String, phone: String?, email: String?, completion: @escaping (Contact?) -> Void){
        let newContact = Contact(name: name, phone: phone, email: email)
        let newRecord = CKRecord(contact: newContact)
        CKContainer.default().publicCloudDatabase.save(newRecord) { (record, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let record = record else {return}
            let contact = Contact(ckRecord: record)
            guard let unwrappedContactContact = contact else {return}
            self.contacts.append(unwrappedContactContact)
            completion(unwrappedContactContact)
        }
    }
    
    func fetchContacts(completion: @escaping ([Contact]?) -> Void){
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.ContactRecordType, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let records = records else {return}
            let contacts: [Contact] = records.compactMap{Contact(ckRecord: $0)}
            self.contacts = contacts
            completion(contacts)
        }
        
    }
    
    func save(name: String, email: String?, phone: String?, completion: @escaping ((Contact)?) -> Void ){
        let contact = Contact(name: name, phone: phone, email: email)
        let record = CKRecord(contact: contact)
        CKContainer.default().publicCloudDatabase.save(record) { (ckRecord, error) in
            if let error = error {
                print("errorStuff \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let ckRecord = ckRecord,
                let contact = Contact(ckRecord: ckRecord) else {completion(nil) ; return}
            //I know this is where the saving issue is
            CKContainer.default().publicCloudDatabase.setValue(contact.name, forKey: Constants.nameKey)
            CKContainer.default().publicCloudDatabase.setValue(contact.phone, forKey: Constants.nameKey)
            CKContainer.default().publicCloudDatabase.setValue(contact.email, forKey: Constants.nameKey)
            completion(contact)
        }
    }
}
