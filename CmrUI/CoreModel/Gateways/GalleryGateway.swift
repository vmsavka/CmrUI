//
//  GalleryGateway.swift
//  CmrUI
//

import Foundation

typealias FetchGalleryGatewayCompletionHandler = (_ items: Result<[GalleryItem]>) -> Void
typealias AddGalleryEntityGatewayCompletionHandler = (_ items: Result<GalleryItem>) -> Void
typealias DeleteGalleryEntityGatewayCompletionHandler = (_ items: Result<GalleryItem>) -> Void

protocol GalleryGateway {
    func fetchGallery(completionHandler: @escaping FetchGalleryGatewayCompletionHandler)
    func add(parameters: GalleryItem, completionHandler: @escaping AddGalleryEntityGatewayCompletionHandler)
    func delete(galleryItem: GalleryItem, completionHandler: @escaping DeleteGalleryEntityGatewayCompletionHandler)
}
