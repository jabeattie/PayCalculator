//
//  Individuals.swift
//  PayCalculator
//
//  Created by James Beattie on 17/12/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

enum Response {
    case Success(object: AnyObject?)
    case Failure(error: String)
}

class Individuals {
    
    private let name = "savedIndividuals"
    
    static var sharedInstance = Individuals()
    
    var savedIndividuals: [Individual] = []
    
    init() {
        preparePlistForUse()
    }
    
    func loadSavedIndividuals() -> Response {
        guard let destination = destPath else { return .Failure(error: "No destination path") }
        guard let savedData = FileManager.default.contents(atPath: destination.path) else { return .Failure(error: "No file at destination path") }
        
        if let si = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [Individual] {
            savedIndividuals = si
            return .Success(object: nil)
        }
        return .Failure(error: "Could not unarchive object")
    }
    
    func saveSavedIndividuals() -> Response {
        guard let destination = destPath else { return .Failure(error: "No destination path") }
        let si = NSKeyedArchiver.archiveRootObject(savedIndividuals, toFile: destination.path)
        switch si {
        case true:
            return .Success(object: nil)
        case false:
            return .Failure(error: "Could not save individuals")
        }
    }
    
    func preparePlistForUse() {
        let fm = FileManager.default
        guard let source = sourcePath else { return }
        guard let destination = destPath else { return }
        
        guard let _ = NSArray(contentsOf: source) else { return }
        
        if !fm.fileExists(atPath: destination.path) {
            do {
                try fm.copyItem(atPath: source.path, toPath: destination.path)
                print("PList file copied to Documents folder")
            } catch let error as NSError {
                print("Unable to copy file. ERROR: \(error.localizedDescription)")
                return
            }
        }
    }
    
    var sourcePath: URL? {
        guard let path = Bundle.main.url(forResource: name, withExtension: ".plist") else { return .none }
        return path
    }
    
    var destPath: URL? {
        guard sourcePath != .none else { return .none }
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dir = NSURL(fileURLWithPath: dirPath)
        return dir.appendingPathComponent("\(name).plist")
        
    }
    
    func isIndividualSaved(individual: Individual) -> Bool {
        return savedIndividuals.contains(individual)
    }
    
    func removeIndividual(individual: Individual) -> Response {
        if savedIndividuals.removeObject(object: individual) {
            return .Success(object: nil)
        }
        return .Failure(error: "Could not remove object from saved individuals")
    }
    
}
