//
//  LocaleFileHandler.swift
//  LocalizationTestApp
//
//  Created by Пламен Великов on 3/14/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation

class LocaleFileHandler {
    
    enum LocalFileHandlerError: LocalizedError {
        case noBundleId
        case applicationSupportDirMissing
        case couldNotCreateDirectory(String)
        case missingLocaleFile(String)
        case readingFile
        case couldNotCreateTmpFile
        case couldNotWriteFile
        
        var localizedDescription: String {
            switch self {
            case .noBundleId:
                return Constants.FileHandler.noBundleIdErrorMessage
            case .applicationSupportDirMissing:
                return Constants.FileHandler.applicationSupportDirMissingErrorMessage
            case .couldNotCreateDirectory(let reason):
                return reason
            case .missingLocaleFile(let filename):
                let errorMessage = String(format:Constants.FileHandler.missingLocaleFileErrorMessage, filename)
                return errorMessage
            case .readingFile:
                return Constants.FileHandler.readingFileErrorMessage
            case .couldNotCreateTmpFile:
                return Constants.FileHandler.couldNotCreateTmpFileErrorMessage
            case .couldNotWriteFile:
                return Constants.FileHandler.couldNotWriteFileErrorMessage
            }
        }
    }
    
    // TODO: check where and why we are using this
    typealias FileWritingOperation = ((Bool) -> Void)?
    
    static func initialCopyOfLocaleFiles() {
        let localeFileHandler = LocaleFileHandler()
        var shouldUpdateVersion = true
        // Getting AppllicationSupport directory and BundleDirectory
        let localizationsDirectoryUrl = try? getLocalizationsDirectory()
        let bundleLocalizationsDirectory = Bundle.main.bundleURL.appendingPathComponent(Constants.FileHandler.localizationsPath)
        let bundleLocalizations = try? FileManager.default.contentsOfDirectory(at: bundleLocalizationsDirectory,
                                                                               includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        // First we check if we already have value for last zip version, saved in UserDefaults
        // after that we are trying to read the value for the last zip version from the file we received from backend
        if let lastSavedVersion = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.zipFileVersion) as? Int,
            let lastReadVersion = localeFileHandler.readProjectVersionFile() {
            // Here we check if our version saved in UserDefaults is different from the one we have from the file we read
            if lastSavedVersion != lastReadVersion {
                shouldUpdateVersion = localeFileHandler.updateLocaleFiles(bundleLocalizations: bundleLocalizations, localizationsDirectoryUrl: localizationsDirectoryUrl)
            } else {
                shouldUpdateVersion = false
            }
        } else {
           shouldUpdateVersion = localeFileHandler.copyBundleFilesToLocaleDirectory(bundleLocalizations: bundleLocalizations, localizationsDirectoryUrl: localizationsDirectoryUrl)
        }
        if shouldUpdateVersion {
            // Update last version of the zip if everyhing works correctly
            let version = localeFileHandler.readProjectVersionFile()
            UserDefaults.standard.set(version, forKey: Constants.UserDefaultKeys.zipFileVersion)
        }
    }
    
    /// Copy each file from bundleDirectory to localizations directory in ApplicationsSupport
    /// in order to be able to write.
    /// If out logic is correct we should be here only on the first launching of the project
    func copyBundleFilesToLocaleDirectory(bundleLocalizations: [URL]?, localizationsDirectoryUrl: URL?) -> Bool {
        var shouldUpdateVersion: Bool = false
        bundleLocalizations?.forEach { (url) in
            guard let destinationUrl = localizationsDirectoryUrl?.appendingPathComponent(url.lastPathComponent),
                FileManager.default.fileExists(atPath: url.path),
                !FileManager.default.fileExists(atPath: destinationUrl.path),
                LocaleFileHandler().copy(from: url.path, destinationUrlPath: destinationUrl.path) else {
                shouldUpdateVersion = false
                return
            }
            shouldUpdateVersion = true
        }
        return shouldUpdateVersion
    }
    
    /// Delete old files from applications support(we are using "remove" function here)
    /// and put the new files from bundle directory(we are using "copy" function here)
    /// With other words we are updating files
    ///
    /// - Returns: returns true if everything is successfull and we should update version // TODO: change this
    func updateLocaleFiles(bundleLocalizations: [URL]?, localizationsDirectoryUrl: URL?) -> Bool {
        var shouldUpdateVersion: Bool = false
        bundleLocalizations?.forEach { (url) in
            // Delete old files from applications support(we are using "remove" function here)
            // and put the new files from bundle directory(we are using "copy" function here)
            // With other words we are updating files
            guard
                let destinationUrl = localizationsDirectoryUrl?.appendingPathComponent(url.lastPathComponent),
                FileManager.default.fileExists(atPath: url.path),
                FileManager.default.fileExists(atPath: destinationUrl.path),
                LocaleFileHandler().remove(at: destinationUrl),
                LocaleFileHandler().copy(from: url.path, destinationUrlPath: destinationUrl.path)
                else {
                    shouldUpdateVersion = false
                    return
            }
            shouldUpdateVersion = true
        }
        return shouldUpdateVersion
    }
    
    // TODO: move this
    func readProjectVersionFile() -> Int? {
        var version: Int?
        do {
            let configFileData = LocaleFileHandler.readBackupFile(filename: Constants.FileHandler.zipFileVersionFileName)
            let json = try JSONSerialization.jsonObject(with: configFileData, options: []) as? [String: Any]
            version = json?["project_version"] as? Int
            UserDefaults.standard.set(version, forKey: Constants.UserDefaultKeys.zipFileVersion)
        } catch {
            Logger.log(messageFormat: "Error reading project version")
        }
        
        return version
    }
    
    func remove(at url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch let error {
            // TODO: add special errors in LocalFileHandlerError
            Logger.log(messageFormat: "Error in removing file at url \(url).\(error.localizedDescription)")
            return false
        }
    }
    
    func copy(from urlPath: String, destinationUrlPath: String) -> Bool {
        do {
            try FileManager.default.copyItem(atPath: urlPath, toPath: destinationUrlPath)
            return true
        } catch let error {
            // TODO: add special errors in LocalFileHandlerError
            Logger.log(messageFormat: "Error in copying file from path \(urlPath) to \(destinationUrlPath) .\(error.localizedDescription)")
            return false
        }
    }
    
    /**
     Locale file should be located in Library/ApplicationSupport/{BundleId}/Localizations/{CurrentDomain} directory.
     if there is something wrong with that file backup files are used - in bundle directory
     
     - parameter filename: name of the locale file.
     
     - returns: Data of that file
     */
    static func readLocaleFile(filename: String, domain: String = "") -> Data {
        var fileContents: Data = Data()
        
        do {
            var localizationsDirectoryUrl = try getLocalizationsDirectory()
            if !domain.isEmpty {
                localizationsDirectoryUrl = localizationsDirectoryUrl.appendingPathComponent("\(domain)")
            }
            let localeFileUrl = localizationsDirectoryUrl
                .appendingPathComponent(filename)
                .appendingPathExtension(Constants.FileHandler.jsonFileExtension)
            
            fileContents = try readFile(at: localeFileUrl)
        } catch let error {
            Logger.log(messageFormat: error.localizedDescription)
            Logger.log(messageFormat: Constants.FileHandler.readingLocaleFileErrorMessage, args: [filename])
            fileContents = readBackupFile(filename: filename, domain: domain)
        }
        return fileContents
    }
    
    private static func readFile(at url: URL) throws -> Data {
        var fileContents: Data = Data()
        // Check if locale file exists
        guard FileManager.default.fileExists(atPath: url.path) else {
            let filename = url.lastPathComponent
            throw LocalFileHandlerError.missingLocaleFile(filename)
        }
        
        if let contents = FileManager.default.contents(atPath: url.path) {
            fileContents = contents
        } else {
            throw LocalFileHandlerError.readingFile
        }
        return fileContents
        
    }
    
    /**
     - Bundle definition: A representation of the code and resources stored in a bundle directory on disk.
     */
    /**
     Reads file from backup directory - {BundleDirectory}/Localizations/{CurrentDomain}
     - parameter filename: name of the locale file.
     - returns: Data of that file
     */
    static func readBackupFile(filename: String, domain: String = "") -> Data {
        var fileContents: Data = Data()
        let bundle = Bundle.main
        let directory = domain.isEmpty ? Constants.FileHandler.localizationsPath : "\(Constants.FileHandler.localizationsPath)/\(domain)"
        if let path = bundle.path(forResource: filename, ofType: Constants.FileHandler.jsonFileExtension,
                                  inDirectory: directory, forLocalization: nil),
            let fileHandle = FileHandle(forReadingAtPath: path) {
            fileContents = fileHandle.readDataToEndOfFile()
            fileHandle.closeFile()
        } else {
            Logger.log(messageFormat: Constants.FileHandler.missingBackupFile, args: [filename])
        }
        return fileContents
    }
    
    static func writeToFile(fileName: String, data: Data, domain: String, callback: FileWritingOperation) {
        DispatchQueue.global(qos: .background).async {
            do {
                let localizationsDirectory = try getLocalizationsDirectory().appendingPathComponent("/\(domain)")
                try writeDataToFile(in: localizationsDirectory, fileName: fileName, fileExtension: Constants.FileHandler.jsonFileExtension, contents: data)
                callback?(true)
            } catch let error {
                Logger.log(messageFormat: error.localizedDescription)
                callback?(false)
            }
        }
    }
    
    private static func getLocalizationsDirectory() throws -> URL {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            throw LocalFileHandlerError.noBundleId
        }
        
        guard let applicationSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw LocalFileHandlerError.applicationSupportDirMissing
        }
        
        let localizationsDirectoryUrl = applicationSupportDirectory
            .appendingPathComponent(bundleId)
            .appendingPathComponent(Constants.FileHandler.localizationsPath)
        
        // TODO: refactor this:
        // will create localization directory if there is no directory
        try createDirectoryIfMissing(localizationsDirectoryUrl)
        
        return localizationsDirectoryUrl
    }
    
    private static func writeDataToFile(in directory: URL, fileName: String, fileExtension: String, contents: Data) throws {
        
        let currentLocaleFile = directory
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
        
        let tmpFileUrl = directory
            .appendingPathComponent("\(fileName)_tmp")
            .appendingPathExtension(fileExtension)
        
        // create tmp file with data override if the file exists
        let created = FileManager.default.createFile(atPath: tmpFileUrl.path, contents: contents, attributes: nil)
        
        // Check for file with fileName
        guard created && FileManager.default.fileExists(atPath: tmpFileUrl.path) else {
            throw LocalFileHandlerError.couldNotCreateTmpFile
        }
        
        if FileManager.default.fileExists(atPath: currentLocaleFile.path) {
            // remove file with fileName
            try FileManager.default.removeItem(at: currentLocaleFile)
        }
        // rename tmp file
        try FileManager.default.moveItem(at: tmpFileUrl, to: currentLocaleFile)
    }
    
    /**
     Create Directory if passed url is missing.
     */
    private static func createDirectoryIfMissing(_ directoryUrl: URL) throws {
        let exists = FileManager.default.fileExists(atPath: directoryUrl.path)
        if !exists {
            do {
                try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                throw LocalFileHandlerError.couldNotCreateDirectory(error.localizedDescription)
            }
        }
    }
}

