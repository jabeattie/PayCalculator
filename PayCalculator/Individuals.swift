//
//  Individuals.swift
//  PayCalculator
//
//  Created by James Beattie on 17/12/2016.
//  Copyright © 2016 James Beattie. All rights reserved.
//

import Foundation

class Individuals {
  
  enum Error: Swift.Error {
    case noDestination
    case noFile
    case couldNotUnarchive
    case couldNotSave
  }
    
    private let name = "savedIndividuals"
    
    static var sharedInstance = Individuals()
    
    var savedIndividuals: [Individual] = []
    
    init() {
        preparePlistForUse()
    }
    
    func loadSavedIndividuals() -> Result<Void, Error> {
      guard let destination = destPath else { return .failure(.noDestination) }
      guard let savedData = FileManager.default.contents(atPath: destination.path) else { return .failure(.noFile) }
        
      if let si = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [Individual] {
          savedIndividuals = si
          return .success(())
      }
      return .failure(.couldNotUnarchive)
    }
    
    func saveSavedIndividuals() -> Result<Void, Error> {
        guard let destination = destPath else { return .failure(.noDestination) }
        let si = NSKeyedArchiver.archiveRootObject(savedIndividuals, toFile: destination.path)
        switch si {
        case true:
            return .success(())
        case false:
            return .failure(.couldNotSave)
        }
    }
    
    func preparePlistForUse() {
        let fm = FileManager.default
        guard let source = sourcePath else { return }
        guard let destination = destPath else { return }
        
        guard NSArray(contentsOf: source) != nil else { return }
        
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
    
    func removeIndividual(individual: Individual) -> Result<Void, Error> {
        if savedIndividuals.removeObject(object: individual) {
            return .success(())
        }
        return .failure(.couldNotSave)
    }
}
