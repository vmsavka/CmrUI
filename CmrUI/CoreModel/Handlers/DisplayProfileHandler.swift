//
//  DisplayProfileHandler.swift
//  CmrUI
//

import UIKit
import Foundation

typealias DisplayProfileCompletionHandler = (_ profileItemsArray: Result<[ProfileItem]>) -> Void

protocol DisplayProfileHandler {
    func displayProfile(completionHandler: @escaping DisplayProfileCompletionHandler)
}

class DisplayProfileHandlerImplementation: DisplayProfileHandler {
    let profileItemsArray: [ProfileItem]
    
    init(profileItems: [ProfileItem]?) {
        self.profileItemsArray = profileItems ?? []
    }
    
    // MARK: - DisplayProfileHandler
    
    func displayProfile(completionHandler: @escaping (Result<[ProfileItem]>) -> Void) {
        
        completionHandler(.success(profileItemsArray))
    }
}
