//
//  Contact.swift
//  Contacts
//
//  Created by Colin Smith on 4/12/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    let name: String
    let phone: String?
    let email: String?
    let recordID: CKRecord.ID
    
    init(name: String, phone: String?, email: String?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.name = name
        self.phone = phone
        self.email = email
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord){
        guard let name = ckRecord[Constants.nameKey] as? String,
            let phone = ckRecord[Constants.phoneKey] as? String,
            let email = ckRecord[Constants.emailKey] as? String else {return nil}
        self.init(name: name, phone: phone, email: email, recordID: ckRecord.recordID)
    }
}

extension CKRecord{
    convenience init(contact: Contact){
        self.init(recordType: Constants.ContactRecordType, recordID: contact.recordID)
        self.setValue(contact.name, forKey: Constants.nameKey)
        self.setValue(contact.phone, forKey: Constants.phoneKey)
        self.setValue(contact.email, forKey: Constants.emailKey)
    }
}


struct Constants {
    static let ContactRecordType = "Contact"
    static let nameKey = "Name"
    static let phoneKey = "Phone"
    static let emailKey = "Email"
}
