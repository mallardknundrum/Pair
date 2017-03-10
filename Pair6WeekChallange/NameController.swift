//
//  NameController.swift
//  Pair6WeekChallange
//
//  Created by Jeremiah Hawks on 3/10/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation

class NameController {
    
    static let shared = NameController()
    
    var nameArray: [Name] = []
    var shuffledArray: [Name] = []
    var shuffledArrays: [[Name]] = []
    var isRandom: Bool = false
    
    func shuffleNamesAndBreakIntoPairs() {
        shuffledArray = randomizeArray(array: nameArray)
        shuffledArrays = breakArrayNameOfArrayOfTwos(array: shuffledArray)
    }
    
    func createName(withName name: String) {
        let name = Name(withName: name)
        CloudKitManager.shared.saveRecord(name.cloudKitRecord) { (_, error) in
            if let error = error {
                print("There was a problem saving to the cloud. \n \(error.localizedDescription)")
            }
        }
        nameArray.append(name)
        if isRandom {
            shuffledArray.append(name)
            if shuffledArrays.last?.count == 1 {
                let index = shuffledArrays.count - 1
                shuffledArrays[index].append(name)
            } else {
                shuffledArrays.append([name])
            }
        }
    }
    
    func fetchAllNames(completion: @escaping() -> Void) {
        CloudKitManager.shared.fetchAllNames { (names) in
            self.nameArray = names
            completion()
            return
        }
    }
    
    func removeNameFromArrays(name: Name) {
        for (index, element) in nameArray.enumerated() {
            if element == name {
                nameArray.remove(at: index)
            }
        }
        for (index, element) in shuffledArray.enumerated() {
            if element == name {
                shuffledArray.remove(at: index)
            }
        }
        var arrayIndex: Int?
        var nameIndex: Int?
        for (aIndex, pairArray) in shuffledArrays.enumerated() {
            for (nIndex, element) in pairArray.enumerated() {
                if element == name {
                    arrayIndex = aIndex
                    nameIndex = nIndex
                }
            }
        }
        if let arrayIndex = arrayIndex, let nameIndex = nameIndex {
            shuffledArrays[arrayIndex].remove(at: nameIndex)
        } else { return }
    }
    
    func deleteName(name: Name) {
        guard let recordID = name.CKRecordID else { return }
        CloudKitManager.shared.deleteRecordWithID(recordID) { (_, error) in
            if let error = error {
                print("There was a problem deleting the record from the cloud \n \(error.localizedDescription)")
            }
        }
        removeNameFromArrays(name: name)
    }
    
    // MARK: - Helper functions
    
    func breakArrayNameOfArrayOfTwos(array: [Name]) -> [[Name]] {
        var placeholderArray: [[Name]] = []
        var copyArray = array
        var count = copyArray.count - 1
        while count >= 0 {
            if count > 0 {
                let item1 = copyArray[count]
                let item2 = copyArray[(count - 1)]
                copyArray.remove(at: count)
                copyArray.remove(at: (count - 1))
                placeholderArray.append([item1, item2])
                count = count - 2
            } else {
                let item1 = copyArray[count]
                copyArray.remove(at: count)
                placeholderArray.append([item1])
                count = (count - 1)
            }
        }
        return placeholderArray
    }
    
    func randomizeArray(array: [Name]) -> [Name] {
        var arrayCopy = array
        var tempArray: [Name] = []
        var count = arrayCopy.count
        let startTime = Date()
        while count > 0 {
            for (index, element) in arrayCopy.enumerated() {
                let randomNumber = arc4random_uniform(100)
                if randomNumber == 1 {
                    tempArray.append(element)
                    arrayCopy.remove(at: index)
                    count = arrayCopy.count
                    break
                }
            }
        }
        let endTime = Date()
        let executionTime = endTime.timeIntervalSince(startTime)
        print(executionTime)
        return tempArray
    }
}
