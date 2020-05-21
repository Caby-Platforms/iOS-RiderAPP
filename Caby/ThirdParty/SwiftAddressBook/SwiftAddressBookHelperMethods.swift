//
//  SwiftAddressBookHelperMethods.swift
//  Pods
//
//  Created by Socialbit - Tassilo Karge on 09.03.15.
//
//

import Foundation
import AddressBook

import Foundation
import AddressBook

@available(iOS, deprecated: 9.0)

extension NSString {

	convenience init?(optionalString : String?) {
		if optionalString == nil {
			self.init()
			return nil
		}
		self.init(string: optionalString!)
	}
}

func errorIfNoSuccess(_ call : (UnsafeMutablePointer<Unmanaged<CFError>?>?) -> Bool) -> CFError? {
	var err : Unmanaged<CFError>?
	let success : Bool = call(&err)
	if success {
		return nil
	}
	else {
		return err?.takeRetainedValue()
	}
}


//MARK: methods to convert arrays of ABRecords

func convertRecordsToSources(_ records : CFArray?) -> [SwiftAddressBookSource]? {
	let swiftRecords = (records as NSArray? as? [ABRecord])?.map {(record : ABRecord) -> SwiftAddressBookSource in
		return SwiftAddressBookSource(record: record)
	}
	return swiftRecords
}

func convertRecordsToGroups(_ records : CFArray?) -> [SwiftAddressBookGroup]? {
	let swiftRecords = (records as NSArray? as? [ABRecord])?.map {(record : ABRecord) -> SwiftAddressBookGroup in
		return SwiftAddressBookGroup(record: record)
	}
	return swiftRecords
}

func convertRecordsToPersons(_ records : CFArray?) -> [SwiftAddressBookPerson]? {
	let swiftRecords = (records as NSArray? as? [ABRecord])?.map {(record : ABRecord) -> SwiftAddressBookPerson in
		return SwiftAddressBookPerson(record: record)
	}
	return swiftRecords
}
