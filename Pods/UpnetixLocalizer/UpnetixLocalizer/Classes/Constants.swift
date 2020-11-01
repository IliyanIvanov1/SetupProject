//
//  Constants.swift
//  CryptoSwift
//
//  Created by Nadezhda Nikolova on 26.11.18.
//

import UIKit

struct Constants {
    
    struct RequestErrorHandler {
        static let httpRequestError = "Error: %@"
        static let requestResponseError = "Not http Error(Some kind of network error): %@"
        static let requestHttpResponseError = "HTTP Error: %@"
        static let couldNotCreateUrlRequest = "Couldn't create update request object."
    }
    
    struct Localizer {
        static let emptyLocaleFileError = "File for locale %@ is empty"
        static let changeLocaleMissingLanguageCodeError = "Change locale failed because of missing language code"
        static let emptyBaseUrlError = "Provided Base Url  is empty"
        static let localeIsChangedBeforeFinishUpdate = "Locale has been changed before update request for that locale to finish"
        static let emptyDomainError = "Provided domain is empty"
        static let configurationFile = "Your configuration file contains: %@"
        static let errorReadingConfigFile = "Error in reading configuration file"
        static let configFileName = "configuration"
    }
    
    struct UpdateLocaleService {
        static let parseUpdateResponseFailed = "Parsing response from update request failed. Perhaps json from server is broken."
        static let couldNotUpdateTranslations = "Couldn't update current locale file and in memory translations"
        static let emptyTranslations = "There are no translations to be updated"
        static let emptyVersionFromBackend = "Couldn't receive new version from backend. Please try to update translations again."
        static let currentlyUpdatingMessage = "There is an update that is currently in progress. Your update request is enqueued"
        static let missingUpdateScheme = "Update service was not started because no scheme was provided"
        static let relativePath = "/update_check"
    }
    
    struct FileHandler {
        static let couldNotWriteFileErrorMessage = "Couldn't save updated strings to locale file"
        static let couldNotCreateTmpFileErrorMessage = "Couldn't create or overwrite tmp file to save new strings"
        static let readingFileErrorMessage = "Error occured while reading the file. Will try to read backup file"
        static let missingLocaleFileErrorMessage = "File for locale %@ is missing"
        static let noBundleIdErrorMessage = "No bundle id was specified. Check your project file"
        static let applicationSupportDirMissingErrorMessage = "Application Support dir is missing"
        
        static let missingBackupFile = "Backup file for locale %@ is missing"
        static let jsonFileExtension = "json"
        static let localizationsPath = "Localizations"
        static let readingLocaleFileErrorMessage = "Error occured while reading 5@. Will try to read backup file."
        static let zipFileVersionFileName = "project"
    }
    
    struct UserDefaultKeys {
        static let zipFileVersion = "zipfile-version"
    }
    
    struct LocalesContractor {
        static let errorLoadingLocalesContractor = "Locales Contractor is not initialize correctly"
        static let errorRequestForGetLocales = "Languages are loaded from User Defaults. Request for getting locales failed or return empty list of languages."
        static let relativePath = "locales"
        static let localizationsPath = "localizations"
    }
}
