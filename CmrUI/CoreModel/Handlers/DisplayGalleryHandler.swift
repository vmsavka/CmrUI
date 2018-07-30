//
//  DisplayGalleryHandler.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/24/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import Foundation

typealias DisplayGalleryCompletionHandler = (_ galleryItemsArray: Result<[GalleryItem]>) -> Void

protocol DisplayGalleryHandler {
    func displayGallery(completionHandler: @escaping DisplayGalleryCompletionHandler)
}

class DisplayGalleryHandlerImplementation: DisplayGalleryHandler {
    let galleryGateway: GalleryGateway
    
    init(galleryGateway: GalleryGateway) {
        self.galleryGateway = galleryGateway
    }
    
    // MARK: - DisplayGalleryHandler
    
    func displayGallery(completionHandler: @escaping (Result<[GalleryItem]>) -> Void) {
        self.galleryGateway.fetchGallery { (result) in
            //...Get necessary items by API calls or local cache
            completionHandler(result)
        }
    }
}
