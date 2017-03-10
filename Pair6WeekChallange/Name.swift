//
//  Name.swift
//  Pair6WeekChallange
//
//  Created by Jeremiah Hawks on 3/10/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation
import CloudKit

class Name {
    
    private let nameKey = "name"
    
    var name: String
    let CKRecordID: CKRecordID?
    
    init(withName name: String) {
        self.name = name
        self.CKRecordID = nil
    }
    
    // MARK: - CloudKit
    
    var cloudKitRecord: CKRecord{
        let record = CKRecord(recordType: "Name")
        record.setValue(name, forKey: nameKey)
        return record
    }
    
    init?(CKRecord: CKRecord) {
        guard let name = CKRecord[nameKey] as? String else { return nil }
        self.name = name
        self.CKRecordID = CKRecord.recordID
    }
}
