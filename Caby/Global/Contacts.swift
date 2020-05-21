//
//  Contacts.swift
//  ConnectWheels
//
//  Created by Hyperlink on 13/12/18.
//  Copyright © 2018 Connect Wheels. All rights reserved.
//

import Foundation
import UIKit
@_exported import Contacts
@_exported import ContactsUI
@_exported import AddressBook

class UserContact : NSObject {
    var name : String!
    var phoneNumber : String!
    
    init(name : String , phoneNumber : String ) {
        super.init()
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    override init() {
        super.init()
        self.name = ""
        self.phoneNumber = ""
    }
}

class ContactsList : NSObject{
    
    static let shared : ContactsList = ContactsList()
    
    var arrContacts : [UserContact] = []
    let formatter = CNContactFormatter()
    let store = CNContactStore()
    
    let validTypes = [
        CNLabelPhoneNumberiPhone,
        CNLabelPhoneNumberMobile,
        CNLabelPhoneNumberMain
    ]
    
    let contactStore = CNContactStore()
    var contacts = [CNContact]()
    let keys = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey
        ] as [Any]
    
    override init() {
        super.init()
        self.myfunc()
//        self.fetchContacts()
    }
    
    func myfunc() {
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        debugPrint("\(contact.givenName) tel:\(localizedLabel) -- \(number.stringValue)")
                    }
                }
            }
            debugPrint(contacts)
        } catch {
            print("unable to fetch contacts")
        }
    }
    
    
//    func fetchContacts() {
//
//        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
//
//            store.requestAccess(for: .contacts) { (authorized, error) in
//                if error != nil {
//
//                    GFunction.shared.showSnackBar((error?.localizedDescription)!)
//                    return
//                }
//                if authorized {
//                    self.retrieveContactsWithStore(store: self.store)
//                }
//            }
//        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
//            self.retrieveContactsWithStore(store: store)
//        }
//    }
//
//    func retrieveContactsWithStore(store: CNContactStore , completion : completion? = nil) {
//        do {
//            var allContainers: [CNContainer] = []
//            do {
//                allContainers = try store.containers(matching: nil)
//            } catch {
//                print("Error fetching containers")
//            }
//
//            _ = allContainers.map { (container) -> Void in
//
//                do{
//
//                    let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
//                    //let predicate = CNContact.predicateForContactsMatchingName("John")
//                    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
//
//                    let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
//
//                    //contacts = contacts.filter{ !$0.phoneNumbers.isEmpty }
//
//                    arrContacts = contacts.map { (con) -> UserContact in
//                        let name = JSON(formatter.string(from: con) as Any).stringValue
//                        var number = JSON(con.phoneNumbers.first?.value.stringValue as Any).stringValue
//
//                        let validNumbers = con.phoneNumbers.compactMap { phoneNumber -> String? in
//                            if let label = phoneNumber.label, validTypes.contains(label) {
//                                return phoneNumber.value.value(forKey: "digits") as? String
//                            }
//                            return nil
//                        }
//
//                        if let numberToAdd = validNumbers.first{
//                            number = numberToAdd
//                        }
//
//                        let userCon = UserContact.init(name: name, phoneNumber: number)
//                        return userCon
//                    }
//
//
//                    //callback
//                }catch {
//                    print(error)
//                }
//
//            }
//
//            if let cb = completion{
//                cb(arrContacts)
//            }
//        }
//
//
//    }
//
//    func getContacts(completion : completion?)  {
//        if let cb = completion {
//            if arrContacts.isEmpty{
//                retrieveContactsWithStore(store: store) { (response) in
//                    if let con = response as? [UserContact]{
//                        cb(con)
//                    }
//                }
//            }else{
//                cb(arrContacts)
//            }
//        }
//    }
}
