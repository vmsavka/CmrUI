//
//  Result.swift
//  CmrUI
//

import UIKit

// https://github.com/antitypical/Result
enum Result<T> {
    case success(T)
    case failure(Error)
    
    public func dematerialize() throws -> T {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}
